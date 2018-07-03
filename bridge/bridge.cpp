#include "bridge.h"
#include "IqrfSpiChannel.h"
#include "DpaHandler2.h"

void *spi_new_channel(void *ptr) {
  spi_iqrf_config_struct *cfg = static_cast<spi_iqrf_config_struct *>(ptr);

  return new IqrfSpiChannel(*cfg);
}

void *dpa_new_handler(void *ptr) {
  IqrfSpiChannel *channel = static_cast<IqrfSpiChannel *>(ptr);

  return new DpaHandler2(channel);
}

void blink(void *ptr) {
  DpaHandler2 *handler = static_cast<DpaHandler2 *>(ptr);

  DpaMessage request;
  request.DpaPacket().DpaRequestPacket_t.NADR = 0x00;
  request.DpaPacket().DpaRequestPacket_t.PNUM = 0x06;
  request.DpaPacket().DpaRequestPacket_t.PCMD = 0x03;
  request.DpaPacket().DpaRequestPacket_t.HWPID = 0xFFFF;
  request.SetLength(sizeof(TDpaIFaceHeader));

  auto dt = handler->executeDpaTransaction(request, 1000);
  auto res = dt->get();
}
