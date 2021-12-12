/*
 * https://adventofcode.com/2021/day/12
 */

import 'dart:io';

bool isBigCave(String s) => s.toUpperCase() == s && s != "start" && s != "end";
Iterable<List<String>> dfsFindAllPathsPart1(
  Map<String, List<String>> graph,
  List<String> currentPathStack,
  Set<String> visitedSmallCaves, [
  String start = "start",
  String end = "end",
]) sync* {
  if (start == end) {
    yield currentPathStack + [start];
  }

  currentPathStack.add(start);
  if (!isBigCave(start)) visitedSmallCaves.add(start);
  List<String> possibleNextCaves = graph[start]!
      .where((element) => !visitedSmallCaves.contains(element))
      .toList();

  for (var nextCave in possibleNextCaves) {
    for (var path in dfsFindAllPathsPart1(
        graph, currentPathStack, visitedSmallCaves, nextCave)) {
      yield path;
    }
  }

  visitedSmallCaves.remove(start);
  currentPathStack.removeLast();
}

void main(List<String> args) {
  List<String> connections = File("input.txt").readAsLinesSync();
  Map<String, List<String>> graph = {};
  for (var connection in connections) {
    List<String> tmp = connection.split("-");
    if (graph.containsKey(tmp[0]))
      graph[tmp[0]]!.add(tmp[1]);
    else
      graph[tmp[0]] = [tmp[1]];

    if (graph.containsKey(tmp[1]))
      graph[tmp[1]]!.add(tmp[0]);
    else
      graph[tmp[1]] = [tmp[0]];
  }
  print("Created graph:");
  int keysMaxWidth = graph.keys.fold(
      0, (value, element) => element.length > value ? element.length : value);
  graph.forEach((key, value) =>
      print("\x1B[32m${key.padLeft(keysMaxWidth)}\x1B[0m: $value"));

  print("\x1B[32m## Part 1 ##\x1B[0m");
  int pathsCount = dfsFindAllPathsPart1(graph, [], {})
      .fold<int>(0, (count, element) => count + 1);
  print("Found \x1B[33m$pathsCount\x1B[0m possible paths.");
  print("\x1B[32m## Part 2 ##\x1B[0m");
  
}