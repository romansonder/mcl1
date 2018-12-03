/*************************************************************************
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.      *
* All rights reserved. All use of this software and documentation is     *
* subject to the License Agreement located at the end of this file below.*
*************************************************************************/
/******************************************************************************
 *
 * Description
 * ************* 
 * A program which provides a means to test most of the devices on a Nios
 * Development Board.  The devices covered in this test are, as follows:
 *  - Seven Segment Display
 *  - The D0-D7 LEDs (located just under the FPGA on most Development boards).
 *      The classic "walking" LED will be displayed on these LEDs.
 *  - UART test 
 *      Tests UART functionality for the UART defined as STDOUT.
 *      * JTAG UART device.
 *  - The LCD Display
 *      Displays a short message on the LCD Display.
 *  - Keys/Switches (SW0-SW3 on the Development boards, located right
 *    under the FPGA.
 *      This detects key presses, in a tight loop, and returns any
 *      non-zero value.  
 *  
 * Requirements
 * **************
 * This program requires the following devices to be configured:
 *   an LED PIO named 'led_pio',
 *   a Seven Segment Display PIO named 'seg7',
 *   an LCD Display named 'lcd_display',
 *   a Key PIO named 'key_pio',
 *   a JTAG connection (to test the JTAG UART functionality)
 *
 * 
 * Peripherals Exercised by SW
 * *****************************
 * LEDs
 * Seven Segment Display
 * LCD
 * Keys (SW1-SW3)
 * JTAG UART
 * 
 *
 * Software Files
 * ****************
 * de1_soc_board_diagnostics.c - This file.
 *    - Implements a top level menu allowing the user to choose which 
 * board components to test.
 * 
 * de1_soc_board_diagnostics.h
 *    - A file containing the common includes and definitions for
 * use within this code.
 * 
 */
 
#include "de1_soc_board_diag.h"

/* Declare one global variable to capture the output of the keys (SW1-SW3),
 * when they are pressed.
 */
 
volatile int edge_capture;

/* *********************************************************************
 * Menu related functions 
 * *********************************************************************
 * A valid STDOUT device must be defined for these functions to work.
 *  - a JTAG UART is the recommended STDOUT device.
 */

/* void MenuBegin( char *title )
 * 
 * Function to set the Menu "header".
 */
static void MenuBegin( char *title )
{
  printf("\n\n");
  printf("----------------------------------\n");
  printf("Nios II DE2-Board Diagnostics\n");
  printf("----------------------------------\n");
  printf(" %s\n",title);
}

/**********************************************************************
 * static void MenuItem( char letter, char *string )
 * 
 * Function to define a menu entry.
 *  - Maps a character (defined by 'letter') to a description string
 *    (defined by 'string').
 *
 **********************************************************************/
static void MenuItem( char letter, char *name )
{
  printf("     %c:  %s\n" ,letter, name);
}

/******************************************************************
*  Function: GetInputString
*
*  Purpose: Parses an input string for the character '\n'.  Then
*           returns the string, minus any '\r' characters it 
*           encounters.
*
******************************************************************/
void GetInputString( char* entry, int size, FILE * stream )
{
  int i;
  int ch = 0;
  
  for(i = 0; (ch != '\n') && (i < size); )
  {
    if( (ch = getc(stream)) != '\r')
    {
      entry[i] = ch;
      i++;
    }
  }
}

/* void MenuEnd(char lowLetter, char highLetter)
 * 
 * Function which defines the menu exit/end conditions.
 *  In this context, the character 'q' always means 'exit'.
 *    The code grabs input from STDIN (via the GetInputString function)
 *    and continues until either a 'q' or a character outside of the 
 *    range, enclosed by 'lowLetter' and 'highLetter', is reached.
 */
static int MenuEnd( char lowLetter, char highLetter )
{
  static char entry[4];
  static char ch;

  printf("     q:  Exit\n");
  printf("----------------------------------\n");
  printf("\nSelect Choice (%c-%c): [Followed by <enter>]",lowLetter,highLetter);
  
  GetInputString( entry, sizeof(entry), stdin );
  if(sscanf(entry, "%c\n", &ch))
  {
    if( ch >= 'A' && ch <= 'Z' )
      ch += 'a' - 'A';
    if( ch == 27 )
      ch = 'q';        
  }
  return ch;
}

#ifdef JTAG_UART_NAME
/*******************************************************************************
 * 
 * static void DoJTAGUARTMenu( void )
 * 
 * Generates the JTAG UART testing menu.
 * 
 ******************************************************************************/
static void DoJTAGUARTMenu( void )
{
  static char ch;  
  
  while (1)
  {
    MenuBegin( "JTAG UART Menu" );
    MenuItem( 'a', "Send Lots" );
    MenuItem( 'b', "Receive Chars" );
    ch = MenuEnd('a', 'b');

    switch (ch)
    {
      MenuCase('a', UARTSendLots);
      MenuCase('b', UARTReceiveChars);
    }
    
    if (ch == 'q')
    {
      break;
    }
  }
}
#endif

/*******************************************************************************
 * 
 * Generates the top level menu for this diagnostics program.
 * 
 ******************************************************************************/
static char TopMenu( void )
{
  static char ch;
  //static alt_u8 led8;
  
  /* Output the top-level menu to STDOUT */

  while (1)
  {  
    MenuBegin("Main Menu");
#ifdef LEDG_PIO_NAME
    MenuItem( 'a', "Test green LEDs" );
#endif
#ifdef LEDR_PIO_NAME
    MenuItem( 'b', "Test red LEDs" );
#endif
#ifdef LCD_NAME
    MenuItem( 'c', "LCD Display Test");
#endif
#ifdef KEY_PIO_NAME
    MenuItem( 'd', "Key/Switch Test");
#endif
#ifdef SEG7_NAME
    MenuItem( 'e', "Seven Segment Menu" );
#endif
#ifdef JTAG_UART_NAME
    MenuItem( 'f', "JTAG UART Menu" );
#endif  
    ch = MenuEnd('a', 'f');
    
	// Toggle green LED8
  //pm: no green led on de1_soc
	//led8 = (led8 & 1) ^ 1;
	//IOWR_ALTERA_AVALON_PIO_DATA(LEDG_PIO_BASE, led8<<8);

    switch(ch)
    {
#ifdef LEDG_PIO_NAME
      MenuCase('a',TestGLEDs);
#endif
#ifdef LEDR_PIO_NAME
      MenuCase('b',TestRLEDs);
#endif
#ifdef LCD_NAME
      MenuCase('c',TestLCD);
#endif
#ifdef KEY_PIO_NAME
      MenuCase('d',TestKeys);
#endif
#ifdef SEG7_NAME
      MenuCase('e',TestSeg7);  
#endif
#ifdef JTAG_UART_NAME
      MenuCase('f',DoJTAGUARTMenu);
#endif
      case 'q':	break;
      default:	printf("\n -ERROR: %c is an invalid entry.  Please try again\n", ch); break;
    }
    
    if (ch == 'q' )
      break;
  }
  return( ch );
}

/* ********************************************************************
 * 
 * Peripheral specific functions.
 * 
 * ********************************************************************/

 #ifdef LEDG_PIO_NAME
/* 
 * static void TestGLEDs(void)
 * 
 * This function tests green LED functionality.
 * It exits when the user types a 'q'.
 */
static void TestGLEDs(void)
{
  volatile alt_u16 gled;
  static char ch;
  static char entry[4];
  
  /* Turn the LEDs on. */
  gled = 0xffff;
  IOWR_ALTERA_AVALON_PIO_DATA(LEDG_PIO_BASE, gled);
  printf( "\nAll green LEDs should now be on.\n" );
  printf( "\tPlease press 'q' [Followed by <enter>] to exit this test.\n" );
  
  /* Get the input string for exiting this test. */
  do {
    GetInputString( entry, sizeof(entry), stdin);
    sscanf( entry, "%c\n", &ch );
  } while ( ch != 'q' );
  
  /* Turn the LEDs off and exit. */
  gled = 0x0;
  IOWR_ALTERA_AVALON_PIO_DATA(LEDG_PIO_BASE, gled);
  printf(".....Exiting green LED Test.\n");
}
#endif

#ifdef LEDR_PIO_NAME
/* 
 * static void TestRLEDs(void)
 * 
 * This function tests red LED and SWITCH functionality.
 * It exits when the user types a 'q'.
 */
static void TestRLEDs(void)
{
  volatile alt_u32 rled;
  static char ch;
  static char entry[4];
  
  /* Read SWITCH */
  rled = IORD_ALTERA_AVALON_PIO_DATA(SWITCH_PIO_BASE);

  /* Control the LEDs */
  IOWR_ALTERA_AVALON_PIO_DATA(LEDR_PIO_BASE, rled);
  printf( "\nThe red LEDs selected by the SWITCHes should now be on.\n" );
  printf( "\tPlease press 'q' [Followed by <enter>] to exit this test.\n" );
  
  /* Get the input string for exiting this test. */
  do {
    GetInputString( entry, sizeof(entry), stdin);
    sscanf( entry, "%c\n", &ch );
  } while ( ch != 'q' );
  
  /* Turn the LEDs off and exit. */
  rled = 0x0;
  IOWR_ALTERA_AVALON_PIO_DATA(LEDR_PIO_BASE, rled);
  printf(".....Exiting red LED Test.\n");
}
#endif

#ifdef LCD_NAME
/*******************************************************************************
 * 
 * static void TestLCD( void )
 * 
 * Tests the LCD by printing some simple output to each line.
 * 
 ******************************************************************************/
static void TestLCD( void )
{
  FILE *lcd;
  static char ch;
  static char entry[4];
  
  lcd = fopen(LCD_NAME, "w");
  
  /* Write some simple text to the LCD. */
  if (lcd != NULL )
  {
    fprintf(lcd, "\nThis is the LCD Display.\n");
    fprintf(lcd, "If you can see this, your LCD is functional.\n");
  }
  printf("\nIf you can see messages scrolling on the LCD Display, then it is functional!\n");
  printf( "\tPlease press 'q' [Followed by <enter>] to exit this test.\n" );
  
  /* Get the input string for exiting this test. */
  do {
    GetInputString( entry, sizeof(entry), stdin);
    sscanf( entry, "%c\n", &ch );
  } while ( ch != 'q' );

  /* Send the command sequence to clear the LCD. */
  if (lcd != NULL )
  {
    fprintf(lcd, "%c%s", ESC, CLEAR_LCD_STRING);
  }
  fclose( lcd );

  return;
}
#endif

#ifdef KEY_PIO_NAME
/*********************************************
 * Key/Switch PIO Functions                      
 *********************************************/

/*******************************************************************
 * static void handle_key_interrupts( void* context, alt_u32 id)*
 *                                                                 *  
 * Handle interrupts from the keys.                                *
 * This interrupt event is triggered by a key/switch press.        *
 * This handler sets *context to the value read from the key       *
 * edge capture register.  The key edge capture register           *
 * is then cleared and normal program execution resumes.           *
 * The value stored in *context is used to control program flow    *
 * in the rest of this program's routines.                         *
 ******************************************************************/
static void handle_key_interrupts(void* context)
{
  /* Cast context to edge_capture's type.
   * It is important to keep this volatile,
   * to avoid compiler optimization issues.
   */
  volatile int* edge_capture_ptr = (volatile int*) context;
  /* Store the value in the Key's edge capture register in *context. */
  *edge_capture_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(KEY_PIO_BASE);
  /* Reset the Key's edge capture register. */
  IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_PIO_BASE, 0);
  IORD_ALTERA_AVALON_PIO_EDGE_CAP(KEY_PIO_BASE); //An extra read call to clear of delay through the bridge
}

/* Initialize the key_pio. */
static void init_key_pio()
{
  /* Recast the edge_capture pointer to match the alt_ic_isr_register() function
  * prototype. */
  void* edge_capture_ptr = (void*) &edge_capture;
  /* Enable all 3 key interrupts. */
  IOWR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_PIO_BASE, 0xf);
  /* Reset the edge capture register. */
  IOWR_ALTERA_AVALON_PIO_EDGE_CAP(KEY_PIO_BASE, 0x0);
  /* Register the interrupt handler. */
  alt_ic_isr_register( KEY_PIO_IRQ_INTERRUPT_CONTROLLER_ID, KEY_PIO_IRQ, handle_key_interrupts, edge_capture_ptr, 0x0 );
}

/* Tear down the key_pio. */
static void disable_key_pio()
{
  /* Disable interrupts from the key_pio PIO component. */
  IOWR_ALTERA_AVALON_PIO_IRQ_MASK(KEY_PIO_BASE, 0x0);
  /* Un-register the IRQ handler by passing a null handler. */
  alt_ic_isr_register( KEY_PIO_IRQ_INTERRUPT_CONTROLLER_ID, KEY_PIO_IRQ, NULL, NULL, 0x0 );
}

/*******************************************************************************
 * 
 * static void TestKeys( void )
 * 
 * Generates a loop that exits when all keys/switches have been pressed, 
 * at least, once.
 * 
 * NOTE:  Keys/Switches are not debounced.  A single press of a
 * key may result in multiple messages.
 * 
 ******************************************************************************/
static void TestKeys( void )
{
  alt_u8 keys_tested;
  alt_u8 all_tested;
  /* Variable which holds the last value of edge_capture to avoid 
   * "double counting" key/switch presses
   */
  int last_tested;
  /* Initialize the Keys/Switches (KEY1-KEY3) */
  init_key_pio();
  /* Initialize the variables which keep track of which keys have been tested. */
  keys_tested = 0x0;
  all_tested = 0xf;

  /* Initialize edge_capture to avoid any "false" triggers from
   * a previous run.
   */   
  edge_capture = 0;
  
  /* Set last_tested to a value that edge_capture can never equal
   * to avoid accidental equalities in the while() loop below.
   */    
  last_tested = 0xffff;

  /* Print a quick message stating what is happening */  
  printf("\nA loop will be run all keys have been pressed.\n\n");
  printf("\n\tNOTE:  Once a key press has been detected, for a particular key,\n\tany further presses will be ignored!\n\n");
  
  /* Loop until all keys have been pressed.
   * This happens when keys_tested == all_tested.
   */
  while (  keys_tested != all_tested )
  { 
    if (last_tested == edge_capture)
    {
      continue;
    }
    else
    {
      last_tested = edge_capture;
      switch (edge_capture)
      {
        case 0x1:
          if (keys_tested & 0x1)
          {
            continue;
          }
          else
          {
            printf("\nKey 0 Pressed.\n");
            keys_tested = keys_tested | 0x1;
          } 
          break;
        case 0x2:
          if (keys_tested & 0x2)
          {
            continue;
          } 
          else
          {
            printf("\nKey 1 Pressed.\n");
            keys_tested = keys_tested | 0x2;
          }
          break;
        case 0x4:
          if (keys_tested & 0x4)
          {
            continue;
          }
          else
          {
            printf("\nKey 2 Pressed.\n");
            keys_tested = keys_tested | 0x4;
          }
          break;
        case 0x8:
          if (keys_tested & 0x8)
          {
            continue;
          }
          else
          {
            printf("\nKey 3 Pressed.\n");
            keys_tested = keys_tested | 0x8;
          }
          break;
      }
    }
  }
  /* Disable the key pio. */
  disable_key_pio();

  printf ("\nAll Keys (Key0-Key3) were pressed, at least, once.\n");
  usleep(2000000);
  return;
}
#endif

#ifdef SEG7_NAME
/*********************************************
 * Seven Segment Functions
 *********************************************/

 /*******************************************
 * static void TestSeg7( void )
 * 
 * Displays from 0 to FF on the Seven Segment Display with
 * a 0.25s count delay implemented in a for loop.
 *******************************************/
static void TestSeg7( void )
{
  alt_u32 count;
  
  //
  printf( "\nAll segments should count from 0 to F.\n" );
  
  for (count = 0; count <= 0xf; count++)
  {
    alt_u32 data = (count << 28) | (count << 24) |
                   (count << 20) | (count << 16) |
				   (count << 12) | (count <<  8) |
				   (count <<  4) | (count <<  0);

    IOWR_IME_AVALON_SEG7_DATA(SEG7_BASE, data);
    usleep(500000);
  }
  usleep(1500000);
  IOWR_IME_AVALON_SEG7_DATA(SEG7_BASE, 0);
  
  printf(".....Exiting Seg7 Test.\n");
}
#endif

#ifdef JTAG_UART_NAME
/****************************************************
 * UART Functions
 * 
 ****************************************************/

/****************************************************
 * static void UARTSendLots( void )
 * 
 * Function which sends blocks/lots of text over the UART
 * 
 * For now, it is hardcoded to send 100 lines with 80 
 * characters per line.
 * 
 ****************************************************/
static void UARTSendLots( void )
{
  char entry[4];
  static char ch;
  int i,j;
  int mix = 0;

  printf("\n\nPress character (and <enter>), or <space> (and <enter>) for mix: ");
  GetInputString( entry, sizeof(entry), stdin);
  sscanf( entry, "%c\n", &ch );
  printf("%c\n\n",ch);
  
  /* Don't print unprintables! */
  if(ch < 32)
    ch = '.';
    
  /* Check to see if the character is a space (for "mix" of chars). */
  
  if (ch == ' ')
  {
    mix = 1;
  }
  
  /* The loop that sends the block of text. */
  
  for(i = 0; i < 100; i++)
  {
    for(j = 0; j < 80; j++)
    {
      if(mix)
      {
        ch++;
        if(ch >= 127)
          ch = 33;
      }
      printf("%c", ch);
    }
    printf("\n");
  }
  printf("\n");
}

/*************************************************
 * 
 * static void UARTReceiveChars(void)
 * 
 * Typed characters will be repeated on the terminal connection.
 * 
 * Entering 'q' will end the session.
 *
 ************************************************/
static void UARTReceiveChars(void)
{
  static char entry[4];
  static char ch;
  static char chP;

  printf("\n\nEnter a character (followed by <enter>); \n\tPress 'q' (followed by <enter>) to exit this test.\n\n");
  
  do
  {
    GetInputString( entry, sizeof(entry), stdin );
    sscanf( entry, "%c\n", &ch );
    chP = ch >= 32 ? ch : '.';
    printf("\'%c\' 0x%02x %d\n",chP,ch,ch);
  }
  while( ch != 'q' );
}
#endif

/*************************************************
 * 
 * MAIN
 *
 ************************************************/
int main()
{
  /* Declare variable for received character. */
  int ch;
  
  while (1)
  {
    ch = TopMenu();
    if (ch == 'q')
    {
      printf( "\nExiting from DE2-Board Diagnostics.\n");
      /* Send EOT to nios2-terminal on the other side of the link. */
      printf( "%c", EOT );
      break;
    }
  }
  return( 0 );
}
