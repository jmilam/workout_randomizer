import Mark from"./lib/mark";import $ from"jquery";$.fn.mark=function(r,n){return new Mark(this.get()).mark(r,n),this},$.fn.markRegExp=function(r,n){return new Mark(this.get()).markRegExp(r,n),this},$.fn.markRanges=function(r,n){return new Mark(this.get()).markRanges(r,n),this},$.fn.unmark=function(r){return new Mark(this.get()).unmark(r),this};export default $;