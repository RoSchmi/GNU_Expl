#include <LPC11xx.H>

const uint32_t led_mask[] = {1UL << 18, 1UL << 19, 1UL << 1};
// LED #0, #1 are port B, LED #2 is port D

void   LED_Config(void);
void   LED_Set(void);
void   LED_Clear(void);
__INLINE static void LED_On (uint32_t led);
__INLINE static void LED_Off (uint32_t led);
void   Delay(uint32_t nCount);

uint32_t ctr;

int main(void)
{ 	
   // Configure LED outputs
   LED_Config();

   ctr = 55;
   #define LOOP_COUNT 0x08005
   while(1)
   {
      __NOP();
      ctr = ctr + 1;
      Delay(LOOP_COUNT);
      LED_Set();
      Delay(LOOP_COUNT);
      LED_Clear();
   };
}

void Delay(uint32_t nCount)
{
  while(nCount--)
  {
  __NOP();
  }
}

/*------------------------------------------------------------------------------
  LED pin config
 *------------------------------------------------------------------------------*/

void LED_Config(void)
{
  // Enable clocks to GPIO and IO config block
  // Bit 6: GPIO, bit 16: IO config
  LPC_SYSCON->SYSAHBCLKCTRL |=  ((1<<16) | (1<<6));
	
  __NOP(); // Short time delay
  __NOP();
  __NOP();
	
  // PIO1_5 IO output config
  //  bit[10]  - Open drain (0 = standard I/O, 1 = open drain)
  //  bit[5]   - Hysteresis (0=disable, 1 =enable)
  //  bit[4:3] - MODE(0=inactive, 1 =pulldown, 2=pullup, 3=repeater)
  //  bit[2:0] - Function (0 = IO, 1=~RTS, 2=CT32B0_CAP0)
  LPC_IOCON->PIO1_5 = (0<<10) | (0<<5) | (0<<3) | (0x0);

  // Optional: Turn off clock to I/O Config block to save power
  LPC_SYSCON->SYSAHBCLKCTRL &=  ~(1<<16);

  // Set pin 8 as output
  LPC_GPIO1->DIR = LPC_GPIO1->DIR | (1<<5);	
  return;
}

/*------------------------------------------------------------------------------
  Switch on LEDs
 *------------------------------------------------------------------------------*/
void LED_Set(void)
{
  // Set bit 5 output to 1
  LPC_GPIO1->MASKED_ACCESS[1<<5] = (1<<5);
  return;
}

/*------------------------------------------------------------------------------
  Switch on LEDs
 *------------------------------------------------------------------------------*/

void LED_Clear(void)
{
  // Clear bit 5 output to 1
  LPC_GPIO1->MASKED_ACCESS[1<<5] = 0;
  return;	
}






