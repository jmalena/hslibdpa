#include "bridge.h"
#include "IqrfSpiChannel.h"
#include "DpaHandler2.h"

void blink() {
  spi_iqrf_config_struct cfg = IqrfSpiChannel::SPI_IQRF_CFG_DEFAULT;
  IChannel *spi = new IqrfSpiChannel(cfg);
  DpaHandler2 *handler = new DpaHandler2(spi);

  DpaMessage request;
  request.DpaPacket().DpaRequestPacket_t.NADR = 0x00;
  request.DpaPacket().DpaRequestPacket_t.PNUM = 0x07;
  request.DpaPacket().DpaRequestPacket_t.PCMD = 0x03;
  request.DpaPacket().DpaRequestPacket_t.HWPID = 0xFFFF;
  request.SetLength(sizeof(TDpaIFaceHeader));

  handler->executeDpaTransaction(request, 1000);
}
