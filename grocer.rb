''' Example hash:
{
  "PEANUTBUTTER" => {:price => 3.00, :clearance => true,  :count => 2},
  "KALE"         => {:price => 3.00, :clearance => false, :count => 3}
  "SOY MILK"     => {:price => 4.50, :clearance => true,  :count => 1}
}
'''
require 'pry'
def consolidate_cart(cart)
  hash_cart = {} #talk about edge cases
  cart.each do | item_hash |
    item_name = item_hash.keys[0]
    if !hash_cart.has_key?(item_name)
      how_many = cart.count(item_hash)
      hash_cart[item_name] = item_hash[item_name]
      hash_cart[item_name][:count] = how_many
    end
  end
  hash_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    item_name = coupon_hash[:item]
    if valid_coupon?(cart,coupon_hash)
      coupond_item = {} #first make a copy of the item
      mult = divide_remain(cart[item_name][:count],coupon_hash[:num])
      cart[item_name][:count] -= (coupon_hash[:num]*mult) #then adjust the full price count
      coupond_item[:price] = coupon_hash[:cost]
      coupond_item[:count] = mult
      coupond_item[:clearance] = cart[item_name][:clearance]
      #binding.pry

      cart["#{item_name} W/COUPON"] = coupond_item
    end
  end
  cart
end

def apply_clearance(cart)
  percent_off = 0.2
  cart.each do |item_name, data|
    if data[:clearance] == true
      data[:price] -= data[:price]*percent_off
    end
  end
  cart
end

def checkout(cart, coupons)
  discount_level_10 = 100
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart,coupons)
  cart = apply_clearance(cart)
  total = cart.reduce(0) do |total, item|
    total + (item[1][:price] * item[1][:count])
  end
  if total >= discount_level_10
    total = total * 0.9
  end
  total
  # code here
end
=begin Some old code that I don't need
def index_for_item(cart,item_name)
  cart.find_index {|item| if item[0] ==item_name; true; end}
end
=end
def valid_coupon?(cart, coupon) #figure things out homie!
  coupon_item = coupon[:item]
  count = coupon[:num]
  if cart.has_key?(coupon_item)&& cart[coupon_item][:count] >= count
    return true
  else
    return false
  end
end

def divide_remain(num,dem)
  mult = num / dem
  mult
end
