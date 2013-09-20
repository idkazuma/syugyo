#! /usr/bin/env ruby

# %ruby -v
# ruby 2.0.0p247 (2013-06-27 revision 41674) [x86_64-darwin12.4.0]

# %ruby fee.rb
# "タスクの組み合わせの総比較数は 2843 回"
# "最大報酬額は 1170"
# "最大報酬額を得られる組み合わせは 2 パターン"
# - パターン 1 => 1 回目の組み合わせの比較で導出
# {:fee=>90, :day=>6}{:fee=>130, :day=>9}{:fee=>170, :day=>13}{:fee=>150, :day=>12}{:fee=>110, :day=>9}{:fee=>330, :day=>30}{:fee=>190, :day=>20}
# - パターン 2 => 3 回目の組み合わせの比較で導出
# {:fee=>90, :day=>6}{:fee=>130, :day=>9}{:fee=>170, :day=>13}{:fee=>150, :day=>12}{:fee=>110, :day=>9}{:fee=>330, :day=>31}{:fee=>190, :day=>20}

class Fee
  attr_reader :tasks, :max_fee, :limit_day, :compare_time

  def initialize(tasks, limit_day)
    @max_fee = {total_fee: 0, count: 0, combinations: [], found_time: []}
    @tasks = tasks
    @limit_day = limit_day
    @compare_time = 0
  end

  def sort!
    @tasks.sort!{|a, b| a[:fee].to_f/a[:day]<=>b[:fee].to_f/b[:day]}.reverse!
  end

  def search
    @tasks.each_with_index do |fee, i|
      search_each_fee [i], fee[:day], fee[:fee]
    end
  end

  def display
    p "タスクの組み合わせの総比較数は #{@compare_time} 回"
    p "最大報酬額は #{@max_fee[:total_fee]}"
    p "最大報酬額を得られる組み合わせは #{@max_fee[:count]} パターン"
    @max_fee[:combinations].each_with_index do |combination, i|
      print "\n - パターン #{i+1} => #{@max_fee[:found_time][i]} 回目の組み合わせの比較で導出\n"
      combination.each do |i_fee_day|
        print @tasks[i_fee_day]
      end
    end
  end

  private
  def search_each_fee(combinations, days, total_fee)
    now = combinations[combinations.size - 1]
    if days == @limit_day
      update_max_fee combinations, total_fee
      # p "#{combinations} / #{days} / #{total_fee}"
      return
    end

    has_not_next = true
    for n in now+1..@tasks.size-1 do
      next_days = days + @tasks[n][:day]
      if next_days <= @limit_day
        combinations.push n
        search_each_fee(combinations, next_days, total_fee + @tasks[n][:fee])
        combinations.pop
        has_not_next=false
      end
    end

    if has_not_next
      update_max_fee combinations, total_fee
      # p "#{combinations} / #{days} / #{total_fee}"
    end
  end

  def update_max_fee(combinations, total_fee)
    @compare_time = @compare_time + 1
    if @max_fee[:total_fee] == total_fee
      @max_fee[:count] = @max_fee[:count] + 1
      @max_fee[:combinations].push Marshal.load(Marshal.dump(combinations))
      @max_fee[:found_time].push @compare_time
    elsif @max_fee[:total_fee] < total_fee
      @max_fee[:total_fee] = total_fee
      @max_fee[:count] = 1
      @max_fee[:combinations] = Array.new().push(Marshal.load(Marshal.dump(combinations)))
      @max_fee[:found_time] = Array.new().push(@compare_time)
    end
  end
end

tasks = [
  {fee:130, day:9}, {fee:150, day:12}, {fee:190, day:20}, {fee:190, day:23},
  {fee:230, day:27}, {fee:290, day:33}, {fee:330, day:31}, {fee:70, day:9},
  {fee:330, day:30}, {fee:110, day:9}, {fee:90, day:6}, {fee:310, day:34},
  {fee:330, day:34}, {fee:190, day:22}, {fee:230, day:25}, {fee:170, day:13}
]
limit_day = 100
f = Fee.new tasks, limit_day

# 5,000 回以内の組み合わせの比較で導けるように事前に組み合わせをソート
f.sort!
# 今回の場合以下の順にソートされる
# {:fee=>90, :day=>6, :price=>15.0}
# {:fee=>130, :day=>9, :price=>14.444444444444445}
# {:fee=>170, :day=>13, :price=>13.076923076923077}
# {:fee=>150, :day=>12, :price=>12.5}
# {:fee=>110, :day=>9, :price=>12.222222222222221}
# {:fee=>330, :day=>30, :price=>11.0}
# {:fee=>330, :day=>31, :price=>10.64516129032258}
# {:fee=>330, :day=>34, :price=>9.705882352941176}
# {:fee=>190, :day=>20, :price=>9.5}
# {:fee=>230, :day=>25, :price=>9.2}
# {:fee=>310, :day=>34, :price=>9.117647058823529}
# {:fee=>290, :day=>33, :price=>8.787878787878787}
# {:fee=>190, :day=>22, :price=>8.636363636363637}
# {:fee=>230, :day=>27, :price=>8.518518518518519}
# {:fee=>190, :day=>23, :price=>8.26086956521739}
# {:fee=>70, :day=>9, :price=>7.777777777777778}

f.search
f.display

