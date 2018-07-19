#include <string.h>
#include "bridge.h"
#include "IqrfSpiChannel.h"
#include "DpaHandler2.h"
#include "DpaMessage.h"
#include "IDpaTransaction2.h"
#include "IDpaTransactionResult2.h"

void *spi_new_channel(void *cfg_ptr) {
  spi_iqrf_config_struct *cfg = static_cast<spi_iqrf_config_struct *>(cfg_ptr);

  return new IqrfSpiChannel(*cfg);
}

void *dpa_new_handler(void *channel_ptr) {
  IqrfSpiChannel *channel = static_cast<IqrfSpiChannel *>(channel_ptr);

  return new DpaHandler2(channel);
}

int dpa_send_request(void *handler_ptr, int32_t timeout, uint8_t *res_buf, int len, uint8_t *buf) {
  DpaHandler2 *handler = static_cast<DpaHandler2 *>(handler_ptr);

  DpaMessage request;
  memcpy(request.DpaPacket().Buffer, buf, len);
  request.SetLength(len);

  std::shared_ptr<IDpaTransaction2> transaction = handler->executeDpaTransaction(request, timeout);
  std::unique_ptr<IDpaTransactionResult2> result = transaction->get();
  const DpaMessage &response = result->getResponse();

  memcpy(res_buf, response.DpaPacket().Buffer, MAX_DPA_BUFFER);
  return response.GetLength();
}
