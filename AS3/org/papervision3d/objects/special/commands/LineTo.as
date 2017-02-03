package org.papervision3d.objects.special.commands {	import org.papervision3d.materials.special.VectorShapeMaterial;			import flash.display.Graphics;		import org.papervision3d.core.geom.renderables.Vertex3D;	import org.papervision3d.core.render.data.RenderSessionData;	import org.papervision3d.core.geom.renderables.Vertex3DInstance;			/**	 * @author Mark Barcinski	 */	public class LineTo implements IVectorShape{		public var vertex : Vertex3D;		public function LineTo(vertex : Vertex3D) {			this.vertex = vertex;			}		public function draw(graphics : Graphics , prevDrawn : Boolean) : Boolean {			if(vertex.vertex3DInstance.visible){				if(prevDrawn)					graphics.lineTo(vertex.vertex3DInstance.x , vertex.vertex3DInstance.y);				else					graphics.moveTo(vertex.vertex3DInstance.x , vertex.vertex3DInstance.y);								return true;				}						return false;		}				static private const halfPI :Number = Math.PI/2;		public function drawScaledStroke( prevVertex : Vertex3D, graphics : Graphics, renderSessionData : RenderSessionData , material : VectorShapeMaterial) : void {			if(!vertex.vertex3DInstance.visible)return;						if(!prevVertex.vertex3DInstance.visible){				graphics.moveTo(vertex.vertex3DInstance.x , vertex.vertex3DInstance.y);				return;			}						var focus    :Number = renderSessionData.camera.focus;			var fz       :Number = focus * renderSessionData.camera.zoom;									var v0Scale  :Number = (fz / (focus + vertex.vertex3DInstance.z)) * material.lineThickness;			var v1Scale  :Number = (fz / (focus + prevVertex.vertex3DInstance.z)) * material.lineThickness;									var x0:Number = vertex.vertex3DInstance.x;			var y0:Number = vertex.vertex3DInstance.y;						var x1:Number = vertex.vertex3DInstance.x;			var y1:Number = vertex.vertex3DInstance.y;						var x2:Number = prevVertex.vertex3DInstance.x;			var y2:Number = prevVertex.vertex3DInstance.y;						var x3:Number = prevVertex.vertex3DInstance.x;			var y3:Number = prevVertex.vertex3DInstance.y;					var rot:Number = Math.atan2( x2 - x1 , y2 - y1 );										var tempSin:Number = Math.sin(rot - halfPI);			var tempCos:Number = Math.cos(rot - halfPI);						x0 -= tempSin * v0Scale;			y0 -= tempCos * v0Scale;						x1 += tempSin * v0Scale;			y1 += tempCos * v0Scale;						x2 += tempSin * v1Scale;			y2 += tempCos * v1Scale;						x3 -= tempSin * v1Scale;			y3 -= tempCos * v1Scale;												graphics.lineStyle();			graphics.beginFill(material.lineColor, material.lineAlpha);			graphics.moveTo( x0, y0 );				graphics.curveTo(vertex.vertex3DInstance.x - (Math.sin(rot) * v0Scale), vertex.vertex3DInstance.y - (Math.cos(rot) * v0Scale), x1, y1);			graphics.lineTo( x2, y2 );			graphics.curveTo(prevVertex.vertex3DInstance.x + (Math.sin(rot) * v1Scale), prevVertex.vertex3DInstance.y + (Math.cos(rot) * v1Scale), x3, y3);			graphics.lineTo( x0, y0 );			graphics.endFill();		}	}}