# frozen_string_literal: true

require 'csv'
require 'nokogiri'
require 'open-uri'
require 'thread'

namespace :scrape do
  desc '競艇データをCSVに出力'
  task to_csv: :environment do
    # ユーザーエージェント
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'

    # 保存ディレクトリ作成
    FileUtils.mkdir_p('db/data')

    races_csv_path = 'db/data/2020_races.csv'
    entries_csv_path = 'db/data/2020_race_entries.csv'
    results_csv_path = 'db/data/2020_race_results.csv'

    CSV.open(races_csv_path, 'w') { |csv| csv << %w[id date stadium_id race_number] }
    CSV.open(entries_csv_path, 'w') do |csv|
      csv << %w[race_id boat_number rank flying_count late_count average_st national_win_rate
                national_quinella_rate national_trio_rate local_win_rate local_quinella_rate local_trio_rate motor_quinella_rate motor_trio_rate]
    end
    CSV.open(results_csv_path, 'w') { |csv| csv << %w[race_id rank1_boat rank2_boat rank3_boat rank4_boat rank5_boat rank6_boat trifecta_payout trio_payout exacta_payout quinella_payout] }

    start_date = Date.parse('2020-01-01')
    end_date = Date.parse('2020-01-09')

    races_data = []
    entries_data = []
    results_data = []
    mutex = Mutex.new

    threads = []
    queue = Queue.new

    (start_date..end_date).each { |date| queue.push(date) }

    10.times do |thread_id|
      threads << Thread.new do
        puts "Thread #{thread_id} started"
        while (date = queue.pop(true) rescue nil)
          formatted_date = date.strftime('%Y%m%d')
          puts "Thread #{thread_id}: Processing #{formatted_date}"

          (1..24).each do |jcd_int|
            jcd = format('%02d', jcd_int)

            (1..12).each do |race_no|
              begin
                list_url = "https://www.boatrace.jp/owpc/pc/race/racelist?rno=#{race_no}&jcd=#{jcd}&hd=#{formatted_date}"
                doc = Nokogiri::HTML(URI.open(list_url, 'User-Agent' => user_agent))

                table = doc.css('table')[1]
                next unless table

                race_id = "#{formatted_date}_#{jcd_int}_#{race_no}".freeze
                rows = table.css('tbody tr')

                (0..5).each do |i|
                  row = rows[i * 4]
                  next unless row

                  cells = row.css('td')

                  fl_stats = cells[3]&.text&.strip&.split(/\s+/) || []
                  zenkoku_stats = cells[4]&.text&.strip&.split(/\s+/) || []
                  touchi_stats = cells[5]&.text&.strip&.split(/\s+/) || []
                  motor_stats = cells[6]&.text&.strip&.split(/\s+/) || []

                  mutex.synchronize do
                    races_data << [race_id, date, jcd_int, race_no] if i == 0
                    entries_data << [
                      race_id, i + 1,
                      cells[2].text.match(/\b(A1|A2|B1|B2)\b/)&.[](1) || 'B2',
                      fl_stats[0].to_s.gsub(/\D/, '').to_i,
                      fl_stats[1].to_s.gsub(/\D/, '').to_i,
                      fl_stats[2].to_f,
                      zenkoku_stats[0].to_f, zenkoku_stats[1].to_f, zenkoku_stats[2].to_f,
                      touchi_stats[0].to_f, touchi_stats[1].to_f, touchi_stats[2].to_f,
                      motor_stats[1].to_f, motor_stats[2].to_f
                    ]
                  end
                end

                result_url = "https://www.boatrace.jp/owpc/pc/race/raceresult?rno=#{race_no}&jcd=#{jcd}&hd=#{formatted_date}"
                res_doc = Nokogiri::HTML(URI.open(result_url, 'User-Agent' => user_agent))
                tables = res_doc.css('table')

                # 着順テーブル（最初のテーブル）
                result_table = nil
                tables.each_with_index do |tbl, _idx|
                  tbody = tbl.css('tbody')
                  tbl_rows = tbody.css('tr')
                  if tbl_rows.length >= 6
                    result_table = tbl
                    break
                  end
                end

                if result_table
                  result_rows = result_table.css('tbody tr')

                  # 全6艇の着順を取得
                  ranks = (0..5).map do |r|
                    cells = result_rows[r].css('td')
                    cells[1].text.to_i
                  rescue StandardError
                    nil
                  end

                  # 払戻金テーブル（2番目のテーブル）
                  pay_table = tables[1]
                  
                  trifecta_payout = 0
                  trio_payout = 0
                  exacta_payout = 0
                  quinella_payout = 0

                  if pay_table
                    pay_table.css('tbody tr').each do |tr|
                      text = tr.text
                      payout_cell = tr.css('td.is-p3-01')
                      next unless payout_cell.any?

                      payout = payout_cell.text.gsub(/[,¥円]/, '').to_i

                      if text.include?('3連単')
                        trifecta_payout = payout
                      elsif text.include?('3連複')
                        trio_payout = payout
                      elsif text.include?('2連単')
                        exacta_payout = payout
                      elsif text.include?('2連複')
                        quinella_payout = payout
                      end
                    end
                  end

                  mutex.synchronize do
                    results_data << [race_id, ranks[0], ranks[1], ranks[2], ranks[3], ranks[4], ranks[5], 
                                     trifecta_payout, trio_payout, exacta_payout, quinella_payout]
                  end
                end
              rescue StandardError => e
                puts "Error at #{date} Stadium #{jcd} #{race_no}R: #{e.message}"
              end
            end
          end

          puts "Fetched: #{formatted_date}"
        end
      end
    rescue ThreadError
    end

    threads.each(&:join)

    races_data.sort_by! { |r| [r[1], r[2], r[3]] }
    entries_data.sort_by! { |e| [e[0].split('_')[0], e[0].split('_')[1].to_i, e[0].split('_')[2].to_i, e[1]] }
    results_data.sort_by! { |r| [r[0].split('_')[0], r[0].split('_')[1].to_i, r[0].split('_')[2].to_i] }

    race_id_map = {}
    counter = 1
    races_data.each do |race|
      race_id_map[race[0]] = counter
      counter += 1
    end

    races_data.each_with_index do |race, idx|
      CSV.open(races_csv_path, 'a') { |csv| csv << [idx + 1, race[1], race[2], race[3]] }
    end

    entries_data.each do |entry|
      CSV.open(entries_csv_path, 'a') { |csv| csv << [race_id_map[entry[0]], *entry[1..-1]] }
    end

    results_data.each do |result|
      CSV.open(results_csv_path, 'a') { |csv| csv << [race_id_map[result[0]], *result[1..-1]] }
    end

    puts 'Scraping completed!'
  end
end
