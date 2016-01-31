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
extern char *STD_STANDARD;
static const char *ng1 = "C:/Users/Michal/Desktop/Swing Copters/divider_universal/divider.vhd";
extern char *IEEE_P_3620187407;

unsigned char ieee_p_3620187407_sub_2599119909_3965413181(char *, int , char *, char *);
char *ieee_p_3620187407_sub_436279890_3965413181(char *, char *, char *, char *, int );


int work_a_0473755358_3212880686_sub_3914843275_3057020925(char *t1, int t2)
{
    char t3[368];
    char t4[8];
    char t8[8];
    char t14[8];
    char t20[8];
    int t0;
    char *t5;
    char *t6;
    char *t7;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t15;
    char *t16;
    char *t17;
    char *t18;
    char *t19;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    int t26;
    unsigned char t27;
    int t28;
    int t29;

LAB0:    t5 = (t3 + 4U);
    t6 = ((STD_STANDARD) + 832);
    t7 = (t5 + 88U);
    *((char **)t7) = t6;
    t9 = (t5 + 56U);
    *((char **)t9) = t8;
    xsi_type_set_default_value(t6, t8, 0);
    t10 = (t5 + 80U);
    *((unsigned int *)t10) = 4U;
    t11 = (t3 + 124U);
    t12 = ((STD_STANDARD) + 832);
    t13 = (t11 + 88U);
    *((char **)t13) = t12;
    t15 = (t11 + 56U);
    *((char **)t15) = t14;
    xsi_type_set_default_value(t12, t14, 0);
    t16 = (t11 + 80U);
    *((unsigned int *)t16) = 4U;
    t17 = (t3 + 244U);
    t18 = ((STD_STANDARD) + 832);
    t19 = (t17 + 88U);
    *((char **)t19) = t18;
    t21 = (t17 + 56U);
    *((char **)t21) = t20;
    xsi_type_set_default_value(t18, t20, 0);
    t22 = (t17 + 80U);
    *((unsigned int *)t22) = 4U;
    t23 = (t4 + 4U);
    *((int *)t23) = t2;
    t24 = (t5 + 56U);
    t25 = *((char **)t24);
    t24 = (t25 + 0);
    *((int *)t24) = 0;
    t6 = (t17 + 56U);
    t7 = *((char **)t6);
    t6 = (t7 + 0);
    *((int *)t6) = 0;
    t6 = (t11 + 56U);
    t7 = *((char **)t6);
    t6 = (t7 + 0);
    *((int *)t6) = 1;

LAB2:    t6 = (t17 + 56U);
    t7 = *((char **)t6);
    t26 = *((int *)t7);
    t27 = (t26 < t2);
    if (t27 != 0)
        goto LAB3;

LAB5:    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t26 = *((int *)t7);
    t0 = t26;

LAB1:    return t0;
LAB3:    t6 = (t5 + 56U);
    t9 = *((char **)t6);
    t28 = *((int *)t9);
    t29 = (t28 + 1);
    t6 = (t5 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((int *)t6) = t29;
    t6 = (t11 + 56U);
    t7 = *((char **)t6);
    t26 = *((int *)t7);
    t28 = (t26 * 2);
    t6 = (t11 + 56U);
    t9 = *((char **)t6);
    t6 = (t9 + 0);
    *((int *)t6) = t28;
    t6 = (t17 + 56U);
    t7 = *((char **)t6);
    t26 = *((int *)t7);
    t6 = (t11 + 56U);
    t9 = *((char **)t6);
    t28 = *((int *)t9);
    t29 = (t26 + t28);
    t6 = (t17 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((int *)t6) = t29;
    goto LAB2;

LAB4:;
LAB6:;
}

static void work_a_0473755358_3212880686_p_0(char *t0)
{
    unsigned char t1;
    char *t2;
    unsigned char t3;
    char *t4;
    char *t5;
    unsigned char t6;
    unsigned char t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;

LAB0:    xsi_set_current_line(50, ng1);
    t2 = (t0 + 992U);
    t3 = xsi_signal_has_event(t2);
    if (t3 == 1)
        goto LAB5;

LAB6:    t1 = (unsigned char)0;

LAB7:    if (t1 != 0)
        goto LAB2;

LAB4:
LAB3:    t2 = (t0 + 3848);
    *((int *)t2) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(51, ng1);
    t4 = (t0 + 1512U);
    t8 = *((char **)t4);
    t4 = (t0 + 3960);
    t9 = (t4 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t8, 23U);
    xsi_driver_first_trans_fast(t4);
    goto LAB3;

LAB5:    t4 = (t0 + 1032U);
    t5 = *((char **)t4);
    t6 = *((unsigned char *)t5);
    t7 = (t6 == (unsigned char)3);
    t1 = t7;
    goto LAB7;

}

static void work_a_0473755358_3212880686_p_1(char *t0)
{
    char t13[16];
    char *t1;
    char *t2;
    int t3;
    char *t4;
    unsigned char t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t14;
    char *t15;
    char *t16;
    char *t17;
    unsigned int t18;
    unsigned int t19;
    unsigned char t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    char *t25;
    char *t26;

LAB0:    xsi_set_current_line(59, ng1);
    t1 = (t0 + 2048U);
    t2 = *((char **)t1);
    t3 = *((int *)t2);
    t1 = (t0 + 1352U);
    t4 = *((char **)t1);
    t1 = (t0 + 6284U);
    t5 = ieee_p_3620187407_sub_2599119909_3965413181(IEEE_P_3620187407, t3, t4, t1);
    if (t5 != 0)
        goto LAB3;

LAB4:
LAB5:    t14 = (t0 + 1352U);
    t15 = *((char **)t14);
    t14 = (t0 + 6284U);
    t16 = ieee_p_3620187407_sub_436279890_3965413181(IEEE_P_3620187407, t13, t15, t14, 1);
    t17 = (t13 + 12U);
    t18 = *((unsigned int *)t17);
    t19 = (1U * t18);
    t20 = (23U != t19);
    if (t20 == 1)
        goto LAB7;

LAB8:    t21 = (t0 + 4024);
    t22 = (t21 + 56U);
    t23 = *((char **)t22);
    t24 = (t23 + 56U);
    t25 = *((char **)t24);
    memcpy(t25, t16, 23U);
    xsi_driver_first_trans_fast(t21);

LAB2:    t26 = (t0 + 3864);
    *((int *)t26) = 1;

LAB1:    return;
LAB3:    t6 = xsi_get_transient_memory(23U);
    memset(t6, 0, 23U);
    t7 = t6;
    memset(t7, (unsigned char)2, 23U);
    t8 = (t0 + 4024);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t6, 23U);
    xsi_driver_first_trans_fast(t8);
    goto LAB2;

LAB6:    goto LAB2;

LAB7:    xsi_size_not_matching(23U, t19, 0);
    goto LAB8;

}

static void work_a_0473755358_3212880686_p_2(char *t0)
{
    char *t1;
    char *t2;
    int t3;
    char *t4;
    unsigned char t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    char *t15;
    char *t16;

LAB0:    xsi_set_current_line(62, ng1);
    t1 = (t0 + 2048U);
    t2 = *((char **)t1);
    t3 = *((int *)t2);
    t1 = (t0 + 1352U);
    t4 = *((char **)t1);
    t1 = (t0 + 6284U);
    t5 = ieee_p_3620187407_sub_2599119909_3965413181(IEEE_P_3620187407, t3, t4, t1);
    if (t5 != 0)
        goto LAB3;

LAB4:
LAB5:    t11 = (t0 + 4088);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    t14 = (t13 + 56U);
    t15 = *((char **)t14);
    *((unsigned char *)t15) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t11);

LAB2:    t16 = (t0 + 3880);
    *((int *)t16) = 1;

LAB1:    return;
LAB3:    t6 = (t0 + 4088);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t6);
    goto LAB2;

LAB6:    goto LAB2;

}


extern void work_a_0473755358_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0473755358_3212880686_p_0,(void *)work_a_0473755358_3212880686_p_1,(void *)work_a_0473755358_3212880686_p_2};
	static char *se[] = {(void *)work_a_0473755358_3212880686_sub_3914843275_3057020925};
	xsi_register_didat("work_a_0473755358_3212880686", "isim/test_top_isim_beh.exe.sim/work/a_0473755358_3212880686.didat");
	xsi_register_executes(pe);
	xsi_register_subprogram_executes(se);
}
