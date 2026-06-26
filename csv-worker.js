self.onmessage=e=>{
  const {id,text,mode="tabular"}=e.data||{};
  try{
    self.postMessage({id,progress:{percent:5,stage:"Reading file"}});
    const matrix=[];let row=[],cell="",quoted=false;
    for(let i=0;i<text.length;i++){
      const char=text[i],next=text[i+1];
      if(char==='"'&&quoted&&next==='"'){cell+='"';i++}
      else if(char==='"')quoted=!quoted;
      else if(char===","&&!quoted){row.push(cell.trim());cell=""}
      else if((char==="\n"||char==="\r")&&!quoted){
        if(char==="\r"&&next==="\n")i++;
        row.push(cell.trim());
        if(row.some(Boolean))matrix.push(row);
        if(matrix.length%1000===0)self.postMessage({id,progress:{percent:Math.min(70,Math.round(i/text.length*70)),stage:"Parsing rows"}});
        row=[];cell="";
      }else cell+=char;
    }
    if(cell||row.length){row.push(cell.trim());if(row.some(Boolean))matrix.push(row)}
    if(matrix.length<2)throw new Error("The CSV must contain a header row and at least one data row");
    self.postMessage({id,progress:{percent:75,stage:"Cleaning rows"}});
    let headerIndex=0;
    if(mode==="cdr"){
      const known=/id|call|time|date|agent|status|queue|ring.?group|call.?flow|from|to/i;
      headerIndex=matrix.findIndex(r=>r.filter(c=>known.test(String(c).trim())).length>=2);
      if(headerIndex<0)throw new Error("Could not find a CDR header row");
    }
    const headers=matrix[headerIndex].map((h,i)=>String(h||`Column ${i+1}`).trim());
    self.postMessage({id,progress:{percent:88,stage:"Building summaries"}});
    const rows=matrix.slice(headerIndex+1).filter(r=>r.some(Boolean)&&!/^total$/i.test((r[0]||"").trim())).map(r=>Object.fromEntries(headers.map((h,i)=>[h,r[i]||""])));
    self.postMessage({id,progress:{percent:100,stage:"Complete"},rows});
  }catch(error){
    self.postMessage({id,error:error.message||String(error)});
  }
};
