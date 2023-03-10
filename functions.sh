xyz()
{
  echo first argument=$1
  echo second argument=$2
  echo all arguments=$*
  echo no of arguments=$#
  echo value of a = $a
  b=200

}
a=220
xyz 123 456

echo value of b =$b