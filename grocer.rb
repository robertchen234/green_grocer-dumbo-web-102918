require 'pry'

def consolidate_cart(cart)
  cons = {}
  cart.each do |item|
    item.each do |name, details|
      if details[:count] != nil 
        details[:count] += 1 
      else 
        details[:count] = 1
        cons[name] = details
      end
    end
  end
  cons
end

def apply_coupons(cart, coupons)
  coup = {}
  cart.each do |name, details|
    if coupons.empty? == false
      coupons.each do |coupon|
        if coupon[:item] == name and details[:count] / coupon[:num] >= 1
          original_count = details[:count]
          details[:count] %= coupon[:num]
          coup[name] = details
          coup["#{name} W/COUPON"] = { :price => coupon[:cost], :clearance => details[:clearance], :count => original_count / coupon[:num] }
        else
          coup[name] = details
        end
      end
    else
      coup[name] = details
    end 
  end
  coup
end

def apply_clearance(cart)
  cart.collect do |name, details|
    if details[:clearance] == true
      details[:price] *= 0.8
      details[:price] = details[:price].round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |name, details|
    total += details[:price] * details[:count]
  end
  total > 100 ? total * 0.9 : total
end