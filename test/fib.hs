num fib(num x) {
  
  if (x < 2) return x;
  else return fib(x - 2) + fib(x - 1);

}
  
void main(){

  var before = now();
	System.print(fib(15));
  var after = now();
  System.print(after - before);
  
  
}
