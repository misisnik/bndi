
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name graphic -dir "C:/Users/Morrisiak/Desktop/Swing Copters/graphic/planAhead_run_1" -part xc3s200ft256-5
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "top.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {vga_sync.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {rom_1.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {top.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top top $srcset
add_files [list {top.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s200ft256-5
