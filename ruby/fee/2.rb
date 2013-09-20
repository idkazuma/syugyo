#! /usr/bin/env ruby

class Fee
  attr_reader :fees, :max_fee, :limit_day

  def initialize(fees, limit_day)
    # total_fee, count, combinations
    @max_fee = [0, 0, []]
    @fees = fees
    @limit_day = limit_day
  end

  def sort!
    @fees.sort!{|a, b| a[:fee].to_f/a[:day]<=>b[:fee].to_f/b[:day]}.reverse!
  end

  def search
    @fees.each_with_index do |fee, i|
      search_each_fee [i], fee[:day], fee[:fee]
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
    for n in now+1..@fees.size-1 do
      next_days = days + @fees[n][:day]
      if next_days <= @limit_day
        combinations.push n
        search_each_fee(combinations, next_days, total_fee + @fees[n][:fee])
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
      if @max_fee[0] == total_fee
        @max_fee[1] = @max_fee[1] + 1
        @max_fee[2].push Marshal.load(Marshal.dump(combinations))
      elsif @max_fee[0] < total_fee
        @max_fee[0] = total_fee
        @max_fee[1] = 1
        @max_fee[2] = Array.new().push(Marshal.load(Marshal.dump(combinations)))
      end
  end

end








fees = [
  {fee:130, day:9}, {fee:150, day:12}, {fee:190, day:20}, {fee:190, day:23},
  {fee:230, day:27}, {fee:290, day:33}, {fee:330, day:31}, {fee:70, day:9},
  {fee:330, day:30}, {fee:110, day:9}, {fee:90, day:6}, {fee:310, day:34},
  {fee:330, day:34}, {fee:190, day:22}, {fee:230, day:25}, {fee:170, day:13}
]

# 問題とする fee の一覧, 制限日数
f = Fee.new fees, 100

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
p f.max_fee

