CC = gcc
CFLAGS = -Wall -Wextra
TARGET = hello-c
SRC_DIR = src
OBJ_DIR = obj
PREFIX = /usr/local

SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

install: $(TARGET)
	mkdir -p $(out)/bin
	cp $(TARGET) $(out)/bin/

clean:
	rm -rf $(OBJ_DIR) $(TARGET)

.PHONY: all install clean
