(** User Mathematica initialization file **)

(* 2d *)
SetOptions[Plot,AspectRatio->1,AxesLabel->(Style[#,"Subsubsection"]&/@{"x","y"})]
SetOptions[ParametricPlot,AspectRatio->1,AxesLabel->(Style[#,"Subsubsection"]&/@{"x","y"})]
SetOptions[RegionPlot,AspectRatio->1,AxesLabel->(Style[#,"Subsubsection"]&/@{"x","y"})]

(* 3d *)
SetOptions[Plot3D,AspectRatio->1,AxesLabel->(Style[#,"Subsubsection"]&/@{"x","y","z"})]
SetOptions[ParametricPlot3D,AspectRatio->1,AxesLabel->(Style[#,"Subsubsection"]&/@{"x","y","z"})]
SetOptions[RegionPlot3D,AspectRatio->1,AxesLabel->(Style[#,"Subsubsection"]&/@{"x","y","z"})]
