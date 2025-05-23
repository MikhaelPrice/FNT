package com.fnt.scheduler.model;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalTime;

@AllArgsConstructor
@Data
public class Action {
  private LocalTime time;
  private int dayBitmask;
}
