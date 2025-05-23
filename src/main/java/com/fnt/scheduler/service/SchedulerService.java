package com.fnt.scheduler.service;

import com.fnt.scheduler.model.Action;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class SchedulerService {

  private static final String ACTIONS_FILENAME = "actions.csv";
  private static final String ZONE_ID = "Africa/Lagos";
  private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");

  @Scheduled(cron = "${scheduler.cron}")
  public void runScheduledActions() {
    ZonedDateTime nowInLagos = ZonedDateTime.now(ZoneId.of(ZONE_ID));
    LocalTime lagosTime = nowInLagos.toLocalTime().withSecond(0).withNano(0);
    DayOfWeek lagosDay = nowInLagos.getDayOfWeek();

    log.info("Current Lagos time {} {}", lagosTime, lagosDay);

    List<Action> actions = loadActionsFromCsv();
    actions.stream()
        .filter(
            action ->
                action.getTime().equals(lagosTime)
                    && ((action.getDayBitmask() >> (lagosDay.getValue() - 1)) & 1) != 0)
        .forEach(
            action ->
                log.info(
                    "Some actions are needed to be done at {} ({}) [bitmask={}]\n",
                    action.getTime(),
                    lagosDay,
                    action.getDayBitmask()));
  }

  private List<Action> loadActionsFromCsv() {
    List<Action> actions = new ArrayList<>();
    try (BufferedReader reader =
        new BufferedReader(
            new InputStreamReader(
                Objects.requireNonNull(
                    getClass().getClassLoader().getResourceAsStream(ACTIONS_FILENAME))))) {
      reader
          .lines()
          .filter(line -> !line.isBlank())
          .map(line -> line.split(","))
          .filter(parts -> parts.length == 2)
          .forEach(
              parts -> {
                LocalTime time = LocalTime.parse(parts[0].trim(), TIME_FORMATTER);
                int bitmask = Integer.parseInt(parts[1].trim());
                actions.add(new Action(time, bitmask));
              });
    } catch (Exception e) {
      log.error("Failed to read actions.csv {} ", e.getMessage());
    }
    return actions;
  }
}
