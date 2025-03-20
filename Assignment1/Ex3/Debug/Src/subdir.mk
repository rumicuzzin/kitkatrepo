################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (12.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Src/definitions.s \
../Src/initialise.s \
../Src/taska.s \
../Src/taskc.s \
../Src/taskd.s \
../Src/taske.s 

OBJS += \
./Src/definitions.o \
./Src/initialise.o \
./Src/taska.o \
./Src/taskc.o \
./Src/taskd.o \
./Src/taske.o 

S_DEPS += \
./Src/definitions.d \
./Src/initialise.d \
./Src/taska.d \
./Src/taskc.d \
./Src/taskd.d \
./Src/taske.d 


# Each subdirectory must supply rules for building sources it contributes
Src/%.o: ../Src/%.s Src/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Src

clean-Src:
	-$(RM) ./Src/definitions.d ./Src/definitions.o ./Src/initialise.d ./Src/initialise.o ./Src/taska.d ./Src/taska.o ./Src/taskc.d ./Src/taskc.o ./Src/taskd.d ./Src/taskd.o ./Src/taske.d ./Src/taske.o

.PHONY: clean-Src

