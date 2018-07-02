#include <stdint.h> // spi_iqrf.h does not contains uint8_t
#include "machines_def.h"
#include "spi_iqrf.h"

#ifdef __cplusplus
extern "C" {
#endif
  void *spi_new_channel(spi_iqrf_config_struct *);
  void *dpa_new_handler(void *);
  void blink(void *);
#ifdef __cplusplus
}
#endif
