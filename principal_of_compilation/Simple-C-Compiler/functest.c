int func() {
  int ret = 6;
  return ret;
}

int main() {
    int i = func();
    int result = 1;
    int j = 1;
    for (j; j <= i; j=j+1) {
        result = result * j;
    }

    printf("%d\n",result);
    return 0;
}