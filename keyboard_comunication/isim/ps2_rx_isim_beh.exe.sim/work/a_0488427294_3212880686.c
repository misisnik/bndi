/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/xslade18/Desktop/bndi-master/keyboard_comunication/ps2_rx.vhd";
extern char *IEEE_P_2592010699;
extern char *IEEE_P_3620187407;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );
unsigned char ieee_p_3620187407_sub_3905759485_3965413181(char *, char *, char *, int );


static void work_a_0488427294_3212880686_p_0(char *t0)
{
    char *t1;
    unsigned char t2;
    char *t3;
    char *t4;
    unsigned char t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;

LAB0:    xsi_set_current_line(70, ng0);
    t1 = (t0 + 992U);
    t2 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t2 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4608);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(71, ng0);
    t3 = (t0 + 1672U);
    t4 = *((char **)t3);
    t5 = *((unsigned char *)t4);
    t3 = (t0 + 4720);
    t6 = (t3 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = t5;
    xsi_driver_first_trans_fast(t3);
    goto LAB3;

}

static void work_a_0488427294_3212880686_p_1(char *t0)
{
    char t16[16];
    char t17[16];
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    unsigned int t13;
    unsigned int t14;
    unsigned int t15;
    int t18;
    unsigned int t19;
    char *t20;
    char *t21;
    char *t22;

LAB0:    xsi_set_current_line(76, ng0);
    t1 = (t0 + 2152U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB2;

LAB4:
LAB3:    t1 = (t0 + 4624);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(78, ng0);
    t1 = (t0 + 1832U);
    t5 = *((char **)t1);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)0);
    if (t7 != 0)
        goto LAB5;

LAB7:
LAB6:    xsi_set_current_line(84, ng0);
    t1 = (t0 + 1832U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)1);
    if (t4 != 0)
        goto LAB8;

LAB10:
LAB9:    xsi_set_current_line(93, ng0);
    t1 = (t0 + 1832U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)1);
    if (t4 != 0)
        goto LAB16;

LAB18:
LAB17:    xsi_set_current_line(98, ng0);
    t1 = (t0 + 1832U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB19;

LAB21:
LAB20:    goto LAB3;

LAB5:    xsi_set_current_line(79, ng0);
    t1 = (t0 + 4784);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    *((unsigned char *)t11) = (unsigned char)1;
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(81, ng0);
    t1 = xsi_get_transient_memory(3U);
    memset(t1, 0, 3U);
    t2 = t1;
    memset(t2, (unsigned char)2, 3U);
    t5 = (t0 + 4848);
    t8 = (t5 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t1, 3U);
    xsi_driver_first_trans_fast(t5);
    goto LAB6;

LAB8:    xsi_set_current_line(85, ng0);
    t1 = (t0 + 2312U);
    t5 = *((char **)t1);
    t1 = (t0 + 8096U);
    t6 = ieee_p_3620187407_sub_3905759485_3965413181(IEEE_P_3620187407, t5, t1, 8);
    if (t6 != 0)
        goto LAB11;

LAB13:
LAB12:    xsi_set_current_line(89, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t13 = (7 - 6);
    t14 = (t13 * 1U);
    t15 = (0 + t14);
    t1 = (t2 + t15);
    t5 = (t0 + 1352U);
    t8 = *((char **)t5);
    t3 = *((unsigned char *)t8);
    t9 = ((IEEE_P_2592010699) + 4024);
    t10 = (t17 + 0U);
    t11 = (t10 + 0U);
    *((int *)t11) = 6;
    t11 = (t10 + 4U);
    *((int *)t11) = 0;
    t11 = (t10 + 8U);
    *((int *)t11) = -1;
    t18 = (0 - 6);
    t19 = (t18 * -1);
    t19 = (t19 + 1);
    t11 = (t10 + 12U);
    *((unsigned int *)t11) = t19;
    t5 = xsi_base_array_concat(t5, t16, t9, (char)97, t1, t17, (char)99, t3, (char)101);
    t19 = (7U + 1U);
    t4 = (8U != t19);
    if (t4 == 1)
        goto LAB14;

LAB15:    t11 = (t0 + 4912);
    t12 = (t11 + 56U);
    t20 = *((char **)t12);
    t21 = (t20 + 56U);
    t22 = *((char **)t21);
    memcpy(t22, t5, 8U);
    xsi_driver_first_trans_fast(t11);
    goto LAB9;

LAB11:    xsi_set_current_line(86, ng0);
    t8 = (t0 + 4784);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    *((unsigned char *)t12) = (unsigned char)2;
    xsi_driver_first_trans_fast(t8);
    goto LAB12;

LAB14:    xsi_size_not_matching(8U, t19, 0);
    goto LAB15;

LAB16:    xsi_set_current_line(94, ng0);
    t1 = (t0 + 2472U);
    t5 = *((char **)t1);
    t1 = (t0 + 4976);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t10 = (t9 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t5, 8U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(95, ng0);
    t1 = (t0 + 4784);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t8 = (t5 + 56U);
    t9 = *((char **)t8);
    *((unsigned char *)t9) = (unsigned char)3;
    xsi_driver_first_trans_fast(t1);
    goto LAB17;

LAB19:    xsi_set_current_line(101, ng0);
    t1 = (t0 + 4784);
    t5 = (t1 + 56U);
    t8 = *((char **)t5);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)0;
    xsi_driver_first_trans_fast(t1);
    goto LAB20;

}

static void work_a_0488427294_3212880686_p_2(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(107, ng0);

LAB3:    t1 = (t0 + 2632U);
    t2 = *((char **)t1);
    t1 = (t0 + 5040);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 8U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 4640);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_0488427294_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0488427294_3212880686_p_0,(void *)work_a_0488427294_3212880686_p_1,(void *)work_a_0488427294_3212880686_p_2};
	xsi_register_didat("work_a_0488427294_3212880686", "isim/ps2_rx_isim_beh.exe.sim/work/a_0488427294_3212880686.didat");
	xsi_register_executes(pe);
}
