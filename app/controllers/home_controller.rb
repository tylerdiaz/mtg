require 'net/http'
require 'uri'

class HomeController < ApplicationController
  def index
  end

  def search
    price = begin
              card_name = params[:q].clone
              card_name.gsub! " ", "+"
              json = JSON.load(open_url("http://www.mtgprice.com/cardNameSearch?name=#{card_name}"))
              last_price = json.map { |card_data| card_data["lowestPrice"] }.min_by{ |v| v.to_f }
            rescue
              0.0
            end

    render json: {
             n: params[:q],
             i: json[0].try(:[], 'fullImageUrl'),
             v: price.to_f * (params[:amount] ? params[:amount].to_f : 1.0),
             a: (params[:amount] ? params[:amount].to_i : 1)
           }
  end

  def open_url(url)
    Net::HTTP.get(URI.parse(url))
  end
end
