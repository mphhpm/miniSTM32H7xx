/**
  ******************************************************************************
  * @file    stm32h7xx_hal_i2c_ex.h
  * @author  MCD Application Team
  * @brief   Header file of I2C HAL Extended module.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2017 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef STM32H7xx_HAL_I2C_EX_H
#define STM32H7xx_HAL_I2C_EX_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "../../../../lvgl_demo/Drivers/STM32H7xx_HAL_Driver/Inc/stm32h7xx_hal_def.h"

/** @addtogroup STM32H7xx_HAL_Driver
  * @{
  */

/** @addtogroup I2CEx
  * @{
  */

/* Exported types ------------------------------------------------------------*/
/* Exported constants --------------------------------------------------------*/
/** @defgroup I2CEx_Exported_Constants I2C Extended Exported Constants
  * @{
  */

/** @defgroup I2CEx_Analog_Filter I2C Extended Analog Filter
  * @{
  */
#define I2C_ANALOGFILTER_ENABLE         0x00000000U
#define I2C_ANALOGFILTER_DISABLE        I2C_CR1_ANFOFF
/**
  * @}
  */

/** @defgroup I2CEx_FastModePlus I2C Extended Fast Mode Plus
  * @{
  */
#define I2C_FMP_NOT_SUPPORTED           0xAAAA0000U                                     /*!< Fast Mode Plus not supported       */
#define I2C_FASTMODEPLUS_PB6            SYSCFG_PMCR_I2C_PB6_FMP                        /*!< Enable Fast Mode Plus on PB6       */
#define I2C_FASTMODEPLUS_PB7            SYSCFG_PMCR_I2C_PB7_FMP                        /*!< Enable Fast Mode Plus on PB7       */
#define I2C_FASTMODEPLUS_PB8            SYSCFG_PMCR_I2C_PB8_FMP                        /*!< Enable Fast Mode Plus on PB8       */
#define I2C_FASTMODEPLUS_PB9            SYSCFG_PMCR_I2C_PB9_FMP                        /*!< Enable Fast Mode Plus on PB9       */
#define I2C_FASTMODEPLUS_I2C1           SYSCFG_PMCR_I2C1_FMP                           /*!< Enable Fast Mode Plus on I2C1 pins */
#define I2C_FASTMODEPLUS_I2C2           SYSCFG_PMCR_I2C2_FMP                           /*!< Enable Fast Mode Plus on I2C2 pins */
#define I2C_FASTMODEPLUS_I2C3           SYSCFG_PMCR_I2C3_FMP                           /*!< Enable Fast Mode Plus on I2C3 pins */
#define I2C_FASTMODEPLUS_I2C4           SYSCFG_PMCR_I2C4_FMP                           /*!< Enable Fast Mode Plus on I2C4 pins */
#if defined(SYSCFG_PMCR_I2C5_FMP)
#define I2C_FASTMODEPLUS_I2C5           SYSCFG_PMCR_I2C5_FMP                           /*!< Enable Fast Mode Plus on I2C5 pins */
#else
#define I2C_FASTMODEPLUS_I2C5           (uint32_t)(0x00001000U | I2C_FMP_NOT_SUPPORTED) /*!< Fast Mode Plus I2C5 not supported  */
#endif
/**
  * @}
  */

/**
  * @}
  */

/* Exported macro ------------------------------------------------------------*/
/** @defgroup I2CEx_Exported_Macros I2C Extended Exported Macros
  * @{
  */

/**
  * @}
  */

/* Exported functions --------------------------------------------------------*/
/** @addtogroup I2CEx_Exported_Functions I2C Extended Exported Functions
  * @{
  */

/** @addtogroup I2CEx_Exported_Functions_Group1 I2C Extended Filter Mode Functions
  * @{
  */
/* Peripheral Control functions  ************************************************/
HAL_StatusTypeDef HAL_I2CEx_ConfigAnalogFilter(I2C_HandleTypeDef *hi2c, uint32_t AnalogFilter);
HAL_StatusTypeDef HAL_I2CEx_ConfigDigitalFilter(I2C_HandleTypeDef *hi2c, uint32_t DigitalFilter);
/**
  * @}
  */

/** @addtogroup I2CEx_Exported_Functions_Group2 I2C Extended WakeUp Mode Functions
  * @{
  */
HAL_StatusTypeDef HAL_I2CEx_EnableWakeUp(I2C_HandleTypeDef *hi2c);
HAL_StatusTypeDef HAL_I2CEx_DisableWakeUp(I2C_HandleTypeDef *hi2c);
/**
  * @}
  */

/** @addtogroup I2CEx_Exported_Functions_Group3 I2C Extended FastModePlus Functions
  * @{
  */
void HAL_I2CEx_EnableFastModePlus(uint32_t ConfigFastModePlus);
void HAL_I2CEx_DisableFastModePlus(uint32_t ConfigFastModePlus);
/**
  * @}
  */


/**
  * @}
  */

/* Private constants ---------------------------------------------------------*/
/** @defgroup I2CEx_Private_Constants I2C Extended Private Constants
  * @{
  */

/**
  * @}
  */

/* Private macros ------------------------------------------------------------*/
/** @defgroup I2CEx_Private_Macro I2C Extended Private Macros
  * @{
  */
#define IS_I2C_ANALOG_FILTER(FILTER)    (((FILTER) == I2C_ANALOGFILTER_ENABLE) || \
                                         ((FILTER) == I2C_ANALOGFILTER_DISABLE))

#define IS_I2C_DIGITAL_FILTER(FILTER)   ((FILTER) <= 0x0000000FU)

#if (defined(SYSCFG_PMCR_I2C1_FMP) && defined(SYSCFG_PMCR_I2C2_FMP) && defined(SYSCFG_PMCR_I2C3_FMP) && defined(SYSCFG_PMCR_I2C4_FMP))
#define IS_I2C_FASTMODEPLUS(__CONFIG__) ((((__CONFIG__) & I2C_FASTMODEPLUS_PB6)  == I2C_FASTMODEPLUS_PB6)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB7)  == I2C_FASTMODEPLUS_PB7)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB8)  == I2C_FASTMODEPLUS_PB8)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB9)  == I2C_FASTMODEPLUS_PB9)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_I2C1) == I2C_FASTMODEPLUS_I2C1) || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_I2C2) == I2C_FASTMODEPLUS_I2C2) || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_I2C3) == I2C_FASTMODEPLUS_I2C3) || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_I2C4) == I2C_FASTMODEPLUS_I2C4))
#elif defined(SYSCFG_PMCR_I2C1_FMP) && defined(SYSCFG_PMCR_I2C2_FMP) && defined(SYSCFG_PMCR_I2C3_FMP)
#define IS_I2C_FASTMODEPLUS(__CONFIG__) ((((__CONFIG__) & I2C_FASTMODEPLUS_PB6)  == I2C_FASTMODEPLUS_PB6)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB7)  == I2C_FASTMODEPLUS_PB7)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB8)  == I2C_FASTMODEPLUS_PB8)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB9)  == I2C_FASTMODEPLUS_PB9)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_I2C1) == I2C_FASTMODEPLUS_I2C1) || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_I2C2) == I2C_FASTMODEPLUS_I2C2) || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_I2C3) == I2C_FASTMODEPLUS_I2C3))
#elif defined(SYSCFG_PMCR_I2C1_FMP) && defined(SYSCFG_PMCR_I2C2_FMP)
#define IS_I2C_FASTMODEPLUS(__CONFIG__) ((((__CONFIG__) & I2C_FASTMODEPLUS_PB6)  == I2C_FASTMODEPLUS_PB6)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB7)  == I2C_FASTMODEPLUS_PB7)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB8)  == I2C_FASTMODEPLUS_PB8)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB9)  == I2C_FASTMODEPLUS_PB9)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_I2C1) == I2C_FASTMODEPLUS_I2C1) || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_I2C2) == I2C_FASTMODEPLUS_I2C2))
#elif defined(SYSCFG_PMCR_I2C1_FMP)
#define IS_I2C_FASTMODEPLUS(__CONFIG__) ((((__CONFIG__) & I2C_FASTMODEPLUS_PB6)  == I2C_FASTMODEPLUS_PB6)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB7)  == I2C_FASTMODEPLUS_PB7)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB8)  == I2C_FASTMODEPLUS_PB8)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_PB9)  == I2C_FASTMODEPLUS_PB9)  || \
                                         (((__CONFIG__) & I2C_FASTMODEPLUS_I2C1) == I2C_FASTMODEPLUS_I2C1))
#endif /* SYSCFG_PMCR_I2C1_FMP && SYSCFG_PMCR_I2C2_FMP && SYSCFG_PMCR_I2C3_FMP && SYSCFG_PMCR_I2C4_FMP */
/**
  * @}
  */

/* Private Functions ---------------------------------------------------------*/
/** @defgroup I2CEx_Private_Functions I2C Extended Private Functions
  * @{
  */
/* Private functions are defined in stm32h7xx_hal_i2c_ex.c file */
/**
  * @}
  */

/**
  * @}
  */

/**
  * @}
  */

#ifdef __cplusplus
}
#endif

#endif /* STM32H7xx_HAL_I2C_EX_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
