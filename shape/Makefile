CC = cc
CFLAGS = -Wall -O2
LDFLAGS =
OBJS = shape.o uc.o util.o

all: shape
%.o: %.c
	$(CC) -c $(CFLAGS) $<
shape: $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS)
clean:
	rm -f *.o shape
