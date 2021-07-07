def consolidate_cart(cart)
	new_cart = {}
  cart.each do |item|
  	item.each do |name, data|
  		if new_cart.has_key?(name)
  			new_cart[name][:count] += 1
  		else
  			new_cart[name] = data
  			data[:count] = 1
  		end
  	end
  end
  new_cart
end

def apply_coupons(cart, coupons)
	return cart if coupons.empty?
  new_cart = {}
  coupons.each do |coupon|
  	cart.each do |item, data|
  		if coupon[:item] == item && coupon[:num] <= data[:count]
  			if new_cart.has_key?(item)
  				new_cart[item][:count] -= coupon[:num]
  				if new_cart.has_key?("#{item} W/COUPON")
  					new_cart["#{item} W/COUPON"][:count] += 1
  				else
  					new_cart["#{item} W/COUPON"] = {
  						:price => coupon[:cost],
  						:clearance => data[:clearance],
  						:count => 1
  					}
  				end
  			else
  				new_cart[item] = data
  				new_cart[item][:count] -= coupon[:num]
  				new_cart["#{item} W/COUPON"] = {
  					:price => coupon[:cost],
  					:clearance => data[:clearance],
  					:count => 1
  				}
  			end
  		else
  			new_cart[item] = data
  		end
  	end
  end
	new_cart
end

def apply_clearance(cart)
	new_cart = {}
  cart.each do |item, data|
  	new_cart[item] = data
  	if data[:clearance]
  		new_cart[item][:price] = (data[:price] * 0.8).round(2)
  	end
  end
  new_cart
end

def checkout(cart, coupons)
  new_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0
  new_cart.each do |item, data|
  	total += (data[:price] * data[:count])
  end
  if total > 100
  	total = (total * 0.9).round(2)
  end
  total
end
