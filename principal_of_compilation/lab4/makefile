.PHONY:lcc,clean,lcc1
lcc:
	flex -+ mylexer.l
	g++ lex.yy.cc -o lcc.out
	./lcc.out test_in2.txt test_out.txt
clean:
	rm*.out
lcc1:
	flex hw4.l
	gcc lex.yy.c -o lcc1.out -ll
	./lcc1.out test_in2.txt test_out.txt