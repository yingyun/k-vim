mount -t debugfs debugfs /d/
cd /d/mdp

dec2hex () {
HEX_DIGITS="0123456789ABCDEF"

dec_value=$offs
hex_value=""

if [ $dec_value -eq 0 ]
then
    hex_value="0"
fi

until [ $dec_value == 0 ]; do

    rem_value=$((dec_value % 16))
    dec_value=$((dec_value / 16))

    hex_digit=${HEX_DIGITS:$rem_value:1}
    hex_value="${hex_digit}${hex_value}"
done
}

counter=0
               
names=  ('OP' 'SYNC' 'OV_STS'  'LM0' 'LM_CFG'   'LM1'  'VG1'  'VG2' 'RGB1' 'RGB2' 'LM2' 'DMA_P' 'DMA_E'  'DTV' 'VIDEO');
offsets=(0      200    10000   10000    100F0   18000  20000  30000  40000  50000 88000   90000   B0000  D0000   E0000);
length= (24      64        1     100        8     101     32     32     32     32   101      64      64     27      64);

#names=  ('LM_CFG'   'LM1'  'VG1'  'VG2' 'RGB1' 'RGB2' 'LM2' 'DMA_P' 'DMA_E'  'DTV' 'VIDEO');
#offsets=(100F0   18000  20000  30000  40000  50000 88000   90000   B0000  D0000   E0000);
#length= (8     101     32     32     32     32   101      64      64     27      64);

while [ $counter -lt 15 ]; do
  len=${length[$counter]}
  loop=$(( $len + 31 ))
  loop=$(( $loop / 32 ))

  echo ----- dump offset : ${offsets[$counter]} : ${names[$counter]}-----
  i=0
  while [ $i -lt $loop ]; do
    offs=${offsets[$counter]}
    let hexoff=0x$offs
    offs=$(( $hexoff + $i * 128 ))
    dec2hex
    hex_off=${hex_value}
    echo $hex_off $len > off
    cat reg
    echo .
    ((i++))
  done

  ((counter++))
done

