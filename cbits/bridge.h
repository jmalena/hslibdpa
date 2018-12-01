#include <stdint.h>

// originally defined in DpaMessage.h
#define MAX_DPA_BUFFER 64

#ifdef __cplusplus
extern "C" {
#endif
  void *spi_new_channel(void *);
  void *dpa_new_handler(void *);
  int dpa_send_request(void *, int32_t, uint8_t *, int, const uint8_t *);
#ifdef __cplusplus
}
#endif
