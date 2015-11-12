
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name keyboard_comunication -dir "C:/Users/xslade18/Desktop/bndi-master/keyboard_comunication/planAhead_run_1" -part xc3s200ft256-5
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "ps2_rx.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {fallingEdgeDetector.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {debouncer.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ps2_rx.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top ps2_rx $srcset
add_files [list {ps2_rx.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s200ft256-5
