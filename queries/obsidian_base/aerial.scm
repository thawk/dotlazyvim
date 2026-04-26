;; 顶层 key（filters / formulas / properties / summaries / views）作为 Property
(document
  (block_node
    (block_mapping
      (block_mapping_pair
        key: (flow_node [(plain_scalar) (double_quote_scalar) (single_quote_scalar)] @name)) @symbol))
  (#set! "kind" "Property"))

;; views 下的每个列表项，提取 name 的值作为子节点
(block_mapping_pair
  key: (flow_node (plain_scalar) @_views (#eq? @_views "views"))
  value: (block_node
    (block_sequence
      (block_sequence_item
        (block_node
          (block_mapping
            (block_mapping_pair
              key: (flow_node (plain_scalar) @_name_key (#eq? @_name_key "name"))
              value: (flow_node [(plain_scalar) (double_quote_scalar) (single_quote_scalar)] @name)))) @symbol))
  (#set! "kind" "Interface"))
