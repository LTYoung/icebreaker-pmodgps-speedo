
TOP_MODULE = speedo
SYNTH_SOURCES += ../provided_modules/inv.sv
SYNTH_SOURCES += ../provided_modules/dff.sv
SYNTH_SOURCES += $(TOP_MODULE).sv


ifneq ($(TOP_MODULE), ringcounter)
SYNTH_SOURCES += ringcounter.sv
endif
ifneq ($(TOP_MODULE), ssd)
SYNTH_SOURCES += ssd.sv
endif
ifneq ($(TOP_MODULE), systemsm)
SYNTH_SOURCES += systemsm.sv
endif
ifneq ($(TOP_MODULE), gpsfixsm)
SYNTH_SOURCES += gpsfixsm.sv
endif
ifneq ($(TOP_MODULE), debouncer)
SYNTH_SOURCES += debouncer.sv
endif
ifneq ($(TOP_MODULE), selector)
SYNTH_SOURCES += selector.sv
endif

ifneq ($(TOP_MODULE), uart_rx_alt)
SYNTH_SOURCES += uart_rx_alt.sv
endif

#SYNTH_SOURCES += if/uart_if.sv


SYNTH_SOURCES +=fifo_1r1w.sv
SYNTH_SOURCES += uds_counter.sv
SYNTH_SOURCES += ram_1w1r_async.sv
SYNTH_SOURCES += ssdflash.sv

ifneq ($(TOP_MODULE), gpsdecodenew)
SYNTH_SOURCES += gpsdecode.sv
endif

SYNTH_SOURCES += gpsspeedo.sv

ifneq ($(TOP_MODULE), kalmanfilter)
SYNTH_SOURCES += kalmanfilter.sv
endif

# open source
#SYNTH_SOURCES += delay.sv
#SYNTH_SOURCES += edge_detect.sv


NONSYNTH_SOURCES += ../provided_modules/nonsynth_clock_gen.sv
NONSYNTH_SOURCES += ../provided_modules/nonsynth_reset_gen.sv
-include ../simulation.mk
-include ../fpga.mk