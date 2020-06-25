function table.merge(t1, t2)
   for k, v in pairs(t2) do
      if type(v) == "table" then
         if type(t1[k] or false) == "table" then
            table.merge(t1[k], t2[k] or {})
         else
            t1[k] = v
         end
      else
         t1[k] = v
      end
   end
end
