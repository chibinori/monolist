class RankingController < ApplicationController
  def have
    rankers = Have.group(:item_id).order('count_all desc').limit(10).count
    @ranker_item_and_counts = []
    rankers.each do | item_id, count |
      ranker_item = Item.find(item_id)
      # １つ目がItemインスタンス、２つ目がその合計カウント
      @ranker_item_and_counts.push([ranker_item, count])  
    end
  end
  
  def want
    rankers = Want.group(:item_id).order('count_all desc').limit(10).count
    @ranker_item_and_counts = []
    rankers.each do | item_id, count |
      ranker_item = Item.find(item_id)
      # １つ目がItemインスタンス、２つ目がその合計カウント
      @ranker_item_and_counts.push([ranker_item, count])  
    end
  end
end
