#include "../stm32wrapper.h"
#include "../newhope.h"


#define NTESTS 1
const char key_stored [32] = {237,173,130,6,49,184,89,218,117,237,0,34,229,122,221,97,55,99,147,19,28,210,57,213,11,184,207,56,167,68,22,122};

void init_dma(int baud){
    clock_setup();
    gpio_setup();
    usart_setup(baud);
    dma_transmit_setup();
    dma_request_setup();
}


void request(poly *sendx){
  unsigned char sendbytes[2048];
  signal_host();
  dma_request(sendbytes, NEWHOPE_SENDABYTES); while (!dma_done());
  //signal_host();
  poly_frombytes_all(sendbytes,sendx);
}

void check_key(unsigned char *key_b){
  char out[5];
  int i,e=1;
  signal_host();
  for (i=0;i<32;i++){
    if(key_b[i] != key_stored[i]){
      out[0] = 'E';
      out[1] = 'r';
      out[2] = 'r';
      out[3] = 'o';
      out[4] = 'r';
      e= 0;
    }
  } 
  if(e){
    out[0] = 'D';
    out[1] = 'o';
    out[2] = 'n';
    out[3] = 'e';
    out[4] = '!';
  }
  dma_transmit(out, 5); while (!dma_done());
}

void send_x(poly *sendx){
  unsigned char sendbytes[256];
  char out[5];
  int i,j;
  signal_host();
  for(i=0;i<1024;i+=128){
    for (j=0;j<256;j+=2){
      sendbytes[j] = sendx->v[i+j/2]  >> 8 ;
      sendbytes[j+1] = sendx->v[i+j/2]& 0xff;
    }
    dma_transmit(sendbytes, 256); while (!dma_done());
  }
}

int test_client(){
  poly CMsendb,sendx;
  unsigned char key_b[32];
  int i;
  request(&sendx);
  newhope_sharedb(key_b, &CMsendb, &sendx);

  send_x(&CMsendb);
  check_key(key_b);

  return 0;

}




int main(){
  init_dma(921600);
  test_client();

  while(1);
}
