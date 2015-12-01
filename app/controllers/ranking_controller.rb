class RankingController < ApplicationController
  def have
    #@rankers = Have.group(:item_id).order('count_all desc').limit(10).count
    @rankers = Have.group(:item_id).order('count_oitems_idl desc').limit(10).count

  end
  
  def want
  end
end
