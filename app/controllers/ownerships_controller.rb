class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    if params[:asin]
      @item = Item.find_or_initialize_by(asin: params[:asin])
    else
      @item = Item.find(params[:item_id])
    end

    # itemsテーブルに存在しない場合はAmazonのデータを登録する。
    if @item.new_record?
      begin
        # 商品情報の取得
        response = Amazon::Ecs.item_lookup( @item.asin, 
                                  :response_group => 'Medium' , 
                                  :country => 'jp')
      rescue Amazon::RequestError => e
        return render :js => "alert('#{e.message}')"
      end

      amazon_item       = response.items.first
      @item.title        = amazon_item.get('ItemAttributes/Title')
      @item.small_image  = amazon_item.get("SmallImage/URL")
      @item.medium_image = amazon_item.get("MediumImage/URL")
      @item.large_image  = amazon_item.get("LargeImage/URL")
      @item.detail_page_url = amazon_item.get("DetailPageURL")
      @item.raw_info        = amazon_item.get_hash
      @item.save!
    end

    # ユーザにwant or haveを設定する
    # params[:type]の値ににHaveボタンが押された時には「Have」,
    # Wantボタンがされた時には「Want」が設定されています。
    
    if params[:type] == "Have"
      current_user.have(@item) if !current_user.have?(@item)
    else
      current_user.want(@item) if !current_user.want?(@item)
    end

    if params[:showed_user_id].present?
      @showed_uesr = User.find(params[:showed_user_id])
    end
  end

  def destroy
    @item = Item.find(params[:item_id])
    
    # 紐付けの解除。 
    # params[:type]の値ににHavedボタンが押された時には「Have」,
    # Wantedボタンがされた時には「Want」が設定されています。
    if params[:type] == "Have"
      current_user.unhave(@item) if current_user.have?(@item)
    else
      current_user.unwant(@item) if current_user.want?(@item)
    end

    if params[:showed_user_id].present?
      @showed_uesr = User.find(params[:showed_user_id])
    end
  end
end
