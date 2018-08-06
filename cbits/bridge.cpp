#include "bridge.h"
#include "IqrfSpiChannel.h"
#include "DpaHandler2.h"
#include "DpaMessage.h"
#include "IDpaHandler2.h"
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

int dpa_send_request(void *handler_ptr, int32_t timeout, uint8_t *out_buf, int in_buf_len, const uint8_t *in_buf) {
  IDpaHandler2 *handler = static_cast<IDpaHandler2 *>(handler_ptr);

  DpaMessage request;
  request.DataToBuffer(in_buf, in_buf_len);

  std::shared_ptr<IDpaTransaction2> transaction = handler->executeDpaTransaction(request, timeout, IDpaTransactionResult2::TRN_OK);
  std::unique_ptr<IDpaTransactionResult2> result = transaction->get();
  const DpaMessage &response = result->getResponse();
  const uint8_t *res_buf = response.DpaPacket().Buffer;
  std::copy(res_buf, res_buf + MAX_DPA_BUFFER, out_buf);

  return response.GetLength();
}
