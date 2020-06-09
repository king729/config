BEGIN {

  flag = 0

}

/BBBBBBBBBBBBBBBB/ {
  flag = 1
  FS = " *= *"

}
flag == 1 {
  if ($1 ~ /CMD ID/) {
     print dict_inv[$2]

  }

}
flag == 0 {
  iter = $1 "" 
  dict_inv[iter] = $2

}

END {

#   for (it in dict_inv) {

 #     print it, dict_inv[it]
 #  }

}
