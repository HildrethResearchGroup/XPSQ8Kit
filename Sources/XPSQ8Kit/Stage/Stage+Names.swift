//
//  Stage+Names.swift
//  
//
//  Created by Connor Barnes on 7/2/21.
//

extension Stage {
  /// Returns the name of the StageGroup that the Stage instance is assigned to.
  ///
  /// - Returns: A string containing the name of the StageGroup.
  private var groupName: String {
    stageGroup.name
  }
  
  /// Returns a String containing the complete stage name for the stage.
  ///
  /// The complete stage name is a combination of the name of the ``StageGroup`` and the name of the stage.  For example: "MacroStages.X" where "MacroStages" is the name of the group, and "X" is the name of the stage. "." is used as the delineator.  These variables are set on the XPS hardware through the Administrator account.
  ///
  /// # Example #
  /// ````
  /// let stageGroup = StageGroup(controller: controller, stageGroupName: "M")
  /// let stage = Stage(stageGroup: stageGroup, stageName: "X")
  /// // Returns "M.X"
  /// let completeStageName = stage.completeStageName
  /// ````
  ///
  /// - Returns: A string containing the fully qualified name of the stage including the ``StageGroup``'s name.
  public var fullyQualifiedName: String {
    [groupName, name].joined(separator: ".")
  }
}
