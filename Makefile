ROOT = /
TARGET = $(BIN_DIR)/system-service
SRC_DIR = ./src
INC_DIR = ./inc
OBJ_DIR = ./obj
BIN_DIR = ./bin
OBJS = $(OBJ_DIR)/main.o \
	   $(OBJ_DIR)/hashtable.o \
	   $(OBJ_DIR)/iniparse.o \
	   $(OBJ_DIR)/dbusfunctions.o
CFLAGS = -Wall -I$(INC_DIR) `pkg-config --cflags dbus-1` `pkg-config --libs dbus-1`

$(TARGET) : $(OBJS)
	@mkdir -p $(BIN_DIR)
	@gcc $(CFLAGS) $(OBJS) -o $(TARGET)

$(OBJ_DIR)/%.o : $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	@gcc -c -MD $(CFLAGS) $< -o $@

-include $(OBJ_DIR)*.d

.PHONY : all
all: $(TARGET)

.PHONY : clean
clean:
	@rm -r $(OBJ_DIR) $(BIN_DIR)

.PHONY : install
install:
	@mkdir -p $(ROOT)/etc/example
	@cp ./etc/daemon.conf $(ROOT)/etc/example
	@cp ./bin/system-service $(ROOT)/usr/local/bin
	@cp ./systemd/system/system-service.service $(ROOT)/etc/systemd/system
	@cp ./systemd/system/com.redhat.SystemService.conf $(ROOT)/etc/dbus-1/system.d

.PHONY : uninstall
uninstall:
	@rm -rf $(ROOT)/etc/example
	@rm $(ROOT)/usr/local/bin/system-service
	@rm $(ROOT)/etc/systemd/system/system-service.service
	@rm $(ROOT)/etc/dbus-1/system.d/com.redhat.SystemService.conf
