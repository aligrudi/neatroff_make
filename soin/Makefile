CC = cc
CFLAGS = -Wall -O2
LDFLAGS =
OBJS = soin.o

all: soin
%.o: %.c
	$(CC) -c $(CFLAGS) $<
soin: $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)
clean:
	rm -f *.o soin
