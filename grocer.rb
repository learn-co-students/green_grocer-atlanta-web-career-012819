def consolidate_cart(cart)
  cart_result = {}
  cart.each do |item|
    item.each do |food, info|
      if cart_result[food]
        cart_result[food][:count] += 1
      else
        cart_result[food] = info
        cart_result[food][:count] = 1
      end
    end
  end
  cart_result
end

def apply_coupons(cart, coupons)
  cart_1 = {}
  cart.each do |items, details|
    coupons.each do |coupon|
      if items == coupon[:item] && details[:count] >= coupon[:num]
        cart[items][:count] = cart[items][:count] - coupon[:num]
        if cart_1[items + " W/COUPON"]
          cart_1[items + " W/COUPON"][:count] += 1
        else
          cart_1[items + " W/COUPON"] = {:price => coupon[:cost], :clearance => cart[items][:clearance], :count => 1}
        end
      end
    end
    cart_1[items] = details
  end
  cart_1
end

def apply_clearance(cart)
  clear_cart_1 = {}
  cart.each do |food, details|
    clear_cart_1[food] = {}
    details.each do |info|
      if cart[food][:clearance]
        clear_cart_1[food][:price] = (cart[food][:price] * 0.80).round(2)
      else 
        clear_cart_1[food][:price] = cart[food][:price]
      end
      clear_cart_1[food][:clearance] = cart[food][:clearance]
      clear_cart_1[food][:count] = cart[food][:count]
    end
  end
  clear_cart_1
end

def checkout(cart, coupons)
  new_cart = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))
  sum = 0
  new_cart.each{|key,value| sum += value[:count]*value[:price]}
  sum > 100 ? sum*0.9.round(2) : sum.round(2)
end

