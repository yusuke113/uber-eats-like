
module Api
  module V1
    class LineFoodsController < ApplicationController
      before_action :set_foods, only: %i[create replace]

      def index
        # 全てのLineFoodモデルactiveなもの取得して、line_foodsという変数に代入
        line_foods = LineFood.active.all # models/line_food.rbのscope :active
        if line_foods.exists?
          render json: {
            line_food_ids: line_foods.map { |line_food| line_food.id },
            restaurant: line_foods[0].restaurant,
            count: line_foods.sum { |line_food| line_food[:count] },
            amount: line_foods.sum { |line_food| line_food.total_amount },
          }, status: :ok
        else
          render json: {}, status: :no_content
        end
      end

      def create
        # models/line_food.rbで定義した scope:other_restaurant
        if LineFoods.active.other_restaurant(@ordered_food.restaurant.id).exists?
          return render json: {
            existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
            new_restaurant: Food.find(params[:food_id]).restaurant.name
          }, status: :not_acceptable
        end
        
        set_line_food(@ordered_food)

        if @line_food.save
          render json: {
            line_food: @line_food
          }, status: :created
        else
          render json: {}, status: :internal_server_error
        end

      end

      def replace
        LineFood.active.other_restaurant(@ordered_food.restaurant_id).each do |line_food|
          line_food.uodate_attribute(:active, false)
        end
        
        set_line_food(@ordered_food)

        if @line_food.save
          render json: {
            line_food: @line_food
          }, status: :created
        else
          render json: {}, status: :internal_server_error
        end
      end


      private
      
        # 注文されたのFoodモデルをsetする
        def set_foods
          @ordered_food = Food.find(params[:food_id])
        end

        # @line_foodに商品と個数を追加して、activeをtrueにする
        def set_line_food(ordered_food)
          # 新規に追加した商品がすでに仮注文にあるかどうか判別
          if ordered_food.line_food.present?
            # すでに注文されている商品だった場合
            @line_food = ordered_food.line_food
            @line_food.attributes = {
              count: ordered_food.line_food.count + params[:count],
              active: true
            }
          # 新しい注文だった場合
          else
            @line_food = ordered_food.build_line_food(
              count: params[:count],
              restaurant: ordered_food.restaurant,
              active: true
            )
          end
        end

    end
  end
end
