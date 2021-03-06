.PHONY: clean

# a test change

all: x_hash3.o libxhash3.so x_hash3 

clean:
	rm -f *.so *.o x_hash2 x_hash3 out.txt

CPPFLAGS+=$(DEBUG)

x_hash: x_hash.o

x_hash2: LDFLAGS=-lhiredis
x_hash2: x_hash2.o

x_hash3: LDFLAGS=-L. -lxhash3  -ldhash -fopenmp
x_hash3: run_words.o 

x_hash3.o:CPPFLAGS=-g -fPIC -fopenmp $(DEBUG)
x_hash3.o:x_hash3.c

run_words.o:CPPFLAGS=-g -fopenmp $(DEBUG)

libxhash3.so: LDFLAGS=-shared -ldhash 
libxhash3.so: OBJECTS=x_hash3.o

libxhash3.so : $(OBJECTS)
	    $(CC) $(CFLAGS) $(OBJECTS) -o $@ $(LDFLAGS) 

test: x_hash3
	time LD_LIBRARY_PATH=. ./x_hash3 in.txt 
	time LD_LIBRARY_PATH=. ./x_hash3 -b 100  4
	time LD_LIBRARY_PATH=. ./x_hash3 -c 100 test-txt
	time LD_LIBRARY_PATH=. ./x_hash3 -o input_file
	time LD_LIBRARY_PATH=. ./x_hash3 -s 2 flower tree 

