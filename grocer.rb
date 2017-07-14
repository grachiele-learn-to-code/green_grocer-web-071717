def consolidate_cart(cart)
  # code here
  returned = {}

  cart.each do |item|
    item.each do |k,v|
      if returned.include?(k)
        returned[k][:count] += 1
      else
        returned[k] = v
        v[:count] = 1
      end
    end
  end
  returned
end

def apply_coupons(cart, coupons)
  # code here
  coupons.each do |coupon|
    if cart.include?(coupon[:item]) == false || cart[coupon[:item]][:count] - coupon[:num] < 0
      next
    elsif cart.include?(coupon[:item]) && cart.include?("#{coupon[:item]} W/COUPON")
      cart["#{coupon[:item]} W/COUPON"][:count] += 1
      cart[coupon[:item]][:count] -= coupon[:num]
    else
      cart["#{coupon[:item]} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[coupon[:item]][:clearance], :count => 1}
      cart[coupon[:item]][:count] = (cart[coupon[:item]][:count] - coupon[:num])
    end
  end
  cart
end

def apply_clearance(cart)
  # code here
  cart.each do |item, info|
    if info[:clearance] == true
      info[:price] = (info[:price] * 0.8).round(1)
    else
      next
    end
  end
end

def checkout(cart, coupons)
  # code here
  total = 0

  total_num = 0

  consolidated = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))

  consolidated.each do |key, value|
    total += (value[:price] * value[:count])
  end

  if total > 100
    total = (total * 0.9).round(2)
    return total
  end

  total
end
