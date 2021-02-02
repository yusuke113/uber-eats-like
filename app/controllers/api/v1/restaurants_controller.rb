
module Api
  module V1
    class RestaurantsController < ApplicationController
      def index
        # レストランのデータを全取得
        restaurants = Restaurant.all

        # json形式でデータを返す
        render json: {
          restaurants: restaurants
        }, status: :ok
      end
    end
  end
end
