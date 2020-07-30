module ModExp where

modexp x y n = if y == 0 then 1 else
  let z = modexp x (y `div` 2) n in
    if even y then (z * z) `mod` n
    else (x * z * z) `mod` n
