# frozen_string_literal: true

namespace :test do
  desc 'parallel_test'
  task parallel_test: :environment do
    start_time = Time.now

    items = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]

    items.each do |item|
    # Parallel.map(items) do |item|
      (1..100).each do |i|
        puts "#{item} - #{i}"
        sleep(0.1)
      end
    end

    end_time = Time.now

    elapsed_time = end_time - start_time

    puts "実行時間：#{elapsed_time.round(2)}秒"
  end
end
