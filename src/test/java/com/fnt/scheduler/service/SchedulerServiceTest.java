package com.fnt.scheduler.service;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import com.fnt.scheduler.Constants;
import com.fnt.scheduler.model.Action;
import java.time.*;
import java.util.Arrays;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;

public class SchedulerServiceTest {

  @Spy private SchedulerService schedulerService;

  @BeforeEach
  public void setUp() {
    MockitoAnnotations.openMocks(this);
  }

  @Test
  public void shouldDoActionsOnMatchedDate() {
    LocalTime timeToDoActions = LocalTime.of(11, 30);
    List<Action> actions =
        Arrays.asList(new Action(timeToDoActions, 32), new Action(LocalTime.now(), 64));

    doReturn(actions).when(schedulerService).loadActionsFromResourceFile(anyString());

    ZonedDateTime zonedDateTime =
        ZonedDateTime.of(
            LocalDate.of(2025, 5, 24), timeToDoActions, ZoneId.of(Constants.ZONE_ID_VALUE));

    DayOfWeek day = zonedDateTime.getDayOfWeek();
    List<Action> actionsToBeDone =
        actions.stream()
            .filter(action -> schedulerService.isActionToBeDone(action, timeToDoActions, day))
            .toList();

    assertEquals(1, actionsToBeDone.size());
  }

  @Test
  public void shouldReturnEmptyOnNonMatchedTime() {
    LocalTime testLocalTime = LocalTime.of(10, 0);
    int bitMask = 1;
    List<Action> actions =
        Arrays.asList(
            new Action(LocalTime.of(9, 0), bitMask), new Action(LocalTime.of(12, 30), bitMask));
    List<Action> filtered =
        actions.stream()
            .filter(
                action ->
                    schedulerService.isActionToBeDone(action, testLocalTime, DayOfWeek.MONDAY))
            .toList();
    assertTrue(filtered.isEmpty());
  }

  @Test
  public void isActionToBeDoneOnCorrectDay() {
    LocalTime testTime = LocalTime.of(14, 30);
    int testBitmask = 5;
    Action action = new Action(testTime, testBitmask);
    assertTrue(schedulerService.isActionToBeDone(action, testTime, DayOfWeek.WEDNESDAY));
  }

  @Test
  public void isActionToBeDoneOnIncorrectDay() {
    LocalTime testTime = LocalTime.of(14, 30);
    int testBitmask = 1;
    Action action = new Action(testTime, testBitmask);
    assertFalse(schedulerService.isActionToBeDone(action, testTime, DayOfWeek.FRIDAY));
  }
}
