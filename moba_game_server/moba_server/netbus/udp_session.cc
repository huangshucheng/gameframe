#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <iostream>
#include <string>
using namespace std;

#include "uv.h"
#include "session.h"
#include "udp_session.h"
#include "proto_man.h"

#include "../utils/small_alloc.h"
#define my_malloc small_alloc
#define my_free small_free

extern "C" {
	static void
		on_uv_udp_send_end(uv_udp_send_t* req, int status) {
		if (status == 0) {
		}
		my_free(req);
	}
}

udp_session::udp_session() :udp_handler(NULL), addr(NULL), c_port(0)
{
	memset(this->c_address, 0, sizeof(this->c_address));
}

udp_session::~udp_session()
{
}

void
udp_session::close() 
{
}

void
udp_session::send_data(unsigned char* body, int len) {
	uv_buf_t w_buf;
	w_buf = uv_buf_init((char*)body, len);
	uv_udp_send_t* req = (uv_udp_send_t*)my_malloc(sizeof(uv_udp_send_t));

	uv_udp_send(req, this->udp_handler, &w_buf, 1, this->addr, on_uv_udp_send_end);
}

const char*
udp_session::get_address(int* port) {
	*port = this->c_port;
	return this->c_address;
}

void
udp_session::send_msg(struct cmd_msg* msg) {
	unsigned char* encode_pkg = NULL;
	int encode_len = 0;
	encode_pkg = proto_man::encode_msg_to_raw(msg, &encode_len);
	if (encode_pkg) {
		this->send_data(encode_pkg, encode_len);
		proto_man::msg_raw_free(encode_pkg);
	}
}